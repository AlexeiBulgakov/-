import sys, os, json, psycopg2, pickle, random, time, datetime, threading

from web3 import Web3, HTTPProvider

from web3.contract import ConciseContract

etreum_id = 8082

web3 = Web3(HTTPProvider('http://localhost:{id}'.format(id = etreum_id))

db = psycopg2.connect("host='localhost' dbname='SCCEvents' user='postgres' password='123qweasd'")

path_to_file = './SmartContracts/'

local_data = None

shem = 'broadwell'

ts = 0.5

k = [0]

def TC(counter):
	counter[0] = counter[0] + 1
	return "{})\t".format(counter[0])

def Deploy():
	sol_names = ["SCCLog", "CNLog", "CMLog", "ULog", "TLog", "GLog", "OLog"]
	
	lock = threading.RLock()
	
	semaphore = threading.BoundedSemaphore(len(sol_names))
	
	def DeploySC(name, time_to_sleep):
		with semaphore:
			MyContract = {
				"bin" : open("{}{}{}".format(path_to_file, name, ".bin")).read(),
				"abi" : open("{}{}{}".format(path_to_file, name, ".abi")).read()
				}
			#creating smart-contracts
			time.sleep(time_to_sleep)
			web3.eth.defaultAccount = web3.eth.accounts[0]
			greeter = web3.eth.contract(abi=MyContract['abi'], bytecode=MyContract['bin'])
			transaction_hash = greeter.constructor().transact()
			#deploying smart-contracts
			tx_receipt = web3.eth.waitForTransactionReceipt(transaction_hash, 360000)
			#saveing smart-contracts address
			with lock:
				with open("{}{}{}".format(dir, "SC_Addresses", ".txt"), "w") as file:
					file.write( "{}\t:\t{}".format(name, tx_receipt.contractAddress) )
					print ( "{}\t:\t{}".format(name, tx_receipt.contractAddress) )
		
	for i, name in enumerate(sol_names):
		my_thread = threading.Thread(target=DeploySC, args=(name, i))
		my_thread.start()
	#whiting of job finish
	time.sleep(5)
	print ("SmartContracts is deployed!")
	
def ControllerInit():
	web3.eth.defaultAccount = web3.eth.accounts[0]
	
def ControllerClose():
	DumpSave()
	db.close()
	
def DumpOpen ():
	try:
		with open("{}{}{}".format(path_to_file, 'DUMP', '.dump'), 'rb') as file:
			return pickle.load(file)
	except:
		return { 'shemname'	: shem,
				 'OLog' 	: [],
				 'GLog' 	: [],
				 'ULog'  	: { 'Sysadmins' : [], 'Admins' : [], 'Users' : [] },
				 'TLog' 	: [],
				 'CMLog' 	: [],
				 'CNLog' 	: [],
				 'SCCLog' 	: [] }
	
def DumpSave ():
	with open("{}{}{}".format(path_to_file, 'DUMP', '.dump'), 'wb') as file:
		pickle.dump(local_data, file, 2)

def Address():
	add = '0xabcda0'
	symbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
	for i in range(9, 43): add += str( symbols[random.randint(0, len(symbols) - 1)] )
	return add

def Datetime(str):
	dt = datetime.datetime.strptime(str, "%Y-%m-%d %H:%M:%S")
	return [dt.year - 2000, dt.month, dt.day, dt.hour, dt.minute, dt.second]

def GetRandomDate(start_date, offcet):
	yyyy 	= start_date[0] + (offcet / 31536000)
	offcet = offcet % 31536000
	mm 		= start_date[1] + (offcet / 2729643)
	offcet = offcet % 2729643
	dd 		= start_date[2] + (offcet / 86400)
	offcet = offcet % 86400
	hh 		= start_date[3] + (offcet / 3600)
	offcet = offcet % 3600
	m 		= start_date[4] + (offcet / 60)
	offcet = offcet % 60
	s 		= start_date[5] + (offcet)
	return [yyyy, mm, dd, hh, m, s]

def GetABI(path_to_file, file_name):
	with open("{}{}{}".format(path_to_file, file_name, '.abi'), 'r') as file:
		return file.read()
		
def GetBIN(path_to_file, file_name):
	with open("{}{}{}".format(path_to_file, file_name, '.bin'), 'r') as file:
		return file.read()


class OLog:
#OLog-controller
	contract_abi = GetABI(path_to_file, 'OLog')
	contract_bin = GetBIN(path_to_file, 'OLog')
	contract_add = Web3.toChecksumAddress("0x358489B8EF4eaC8ea186F1Ad16da7B6a7D61b1A1")
	connect_con = web3.eth.contract(address=contract_add, abi=contract_abi)

	@classmethod
	def DataFromBD(cls):
		res = []
		cur = db.cursor()
		cur.execute("SELECT * FROM public.orgs ORDER BY orgid;")
		row = cur.fetchone()
		while row:
			res.append( {"orgid" : row[0], "orgname" : str(row[1]).strip() , "orghostname" : str(row[2]).strip(), "orgdescr" : str(row[3]).strip() } )
			row = cur.fetchone()
		return res
	
	@classmethod
	def AddOrg(cls, address,*, D):
		SC = cls.connect_con.functions.AddOrg(Web3.toChecksumAddress( address ), str( D['orgname'] ), str( D['orghostname'] ), str( D['orgdescr'] ) )
		SC.transact()
		local_data['OLog'].append( address )
		print( TC(k), "Message ( OLog->AddOrg' ): transaction initiated!" )
	
	@classmethod
	def AddOrgsFromDB(cls):
		for data in cls.DataFromBD():
			cls.AddOrg(Address(), D=data)
			time.sleep(ts)
		print( TC(k), "Message ( OLog->AddOrgsFromDB' ): succressfully added!" )
				
	@classmethod
	def GetOrgsByAddress(cls, address):
		SC = cls.connect_con.functions.GetLastOrg( Web3.toChecksumAddress(address) )
		time.sleep(ts)
		return SC.call()[2:]
	
	@classmethod
	def PrintAllOrgs(cls):
		print('Organizations:')
		for i, address in enumerate(local_data['OLog']):
			print( "{})\t{}".format(i, GetOrgsByAddress(address)) )
	
	
class GLog:
#GLog-controller
	contract_abi = GetABI(path_to_file, 'GLog')
	contract_bin = GetBIN(path_to_file, 'GLog')
	contract_add = Web3.toChecksumAddress("0x3F3738D136A41586f7270A9AE17cCc76Db365c8D")
	connect_con = web3.eth.contract(address=contract_add, abi=contract_abi)

	@classmethod
	def DataFromBD(cls):
		res = []
		cur = db.cursor()
		cur.execute("SELECT * FROM public.groups ORDER BY gid;")
		row = cur.fetchone()
		while row:
			res.append( {"gid" : row[0], "groupname" : str(row[1]).strip() , "projectname" : str(row[2]).strip(), "projectdescr" : str(row[3]).strip() } )
			row = cur.fetchone()
		return res
	
	@classmethod
	def AddGroup(cls, address,*, D):
		SC = cls.connect_con.functions.AddGroup(Web3.toChecksumAddress( address ), str( D['groupname'] ), str( D['projectname'] ), str( D['projectdescr'] ) )
		SC.transact()
		local_data['GLog'].append( address )
		print( TC(k), "Message ( GLog->AddGroup' ): transaction initiated!" )
		
	@classmethod
	def AddGropFromDB(cls):
		for data in cls.DataFromBD():
			cls.AddGroup(Address(), D=data)
			time.sleep(ts)
		print( TC(k), "Message ( GLog->AddGropFromDB' ): succressfully added!" )
	
	@classmethod
	def GetGroupByAddress(cls, address, i):
		SC = cls.connect_con.functions.GetOrg(Web3.toChecksumAddress(address), i)
		time.sleep(ts)
		return SC.call()
	
	@classmethod
	def GetGroupByAddress(cls, address):
		SC = cls.connect_con.functions.GetLastGroup( Web3.toChecksumAddress(address) )
		time.sleep(ts)
		return SC.call()[2:]
	
	@classmethod
	def PrintAllGroup(cls):
		print('Groups:')
		for i, address in enumerate(local_data['GLog']):
			print( "{})\t{}".format(i, GetGroupByAddress(address)) )


class ULog:
	#ULog-controller
	contract_abi = GetABI(path_to_file, 'ULog')
	contract_bin = GetBIN(path_to_file, 'ULog')
	contract_add = Web3.toChecksumAddress("0xC21Eb61166DEe441d46cAEf050033129a17030fA")
	connect_con = web3.eth.contract(address=contract_add, abi=contract_abi)
	
	@classmethod
	def DataFromBDUInfo(cls):
		res = []
		cur = db.cursor()
		cur.execute(
"""SELECT U.userid as "userid", U.loginname as "login", 'SCC = {}' as "description"
	FROM public.users as U;""".format(local_data['shemname']))
		row = cur.fetchone()
		while row:
			res.append( {"userid" : row[0], "createtime" : Datetime( str(datetime.datetime.now())[:-7] ), "login" : str(row[1]).strip() , "description" : str(row[2]).strip() } )
			row = cur.fetchone()
		return res
	
	@classmethod
	def AddSysadmin(cls, address,*, D):
		SC = cls.connect_con.functions.AddUser(
				Web3.toChecksumAddress( address ),
				int( D['createtime'][0] ), int( D['createtime'][1] ), int( D['createtime'][2] ), int( D['createtime'][3] ), int( D['createtime'][4] ), int( D['createtime'][5] ),
				int ( 0 ),
				str( D['login'] ),
				str( D['description'] )
			)
		SC.transact( { 'gas': 30000 } )
		local_data['ULog']['Sysadmins'].append( address )
		print ( TC(k), "Message ( OLog->AddSysadmin' ): transaction initiated!" )
		
	@classmethod
	def AddAdmin(cls, address,*, D):
		SC = cls.connect_con.functions.AddUser(
				Web3.toChecksumAddress( address ),
				int( D['createtime'][0] ), int( D['createtime'][1] ), int( D['createtime'][2] ), int( D['createtime'][3] ), int( D['createtime'][4] ), int( D['createtime'][5] ),
				int ( 1 ),
				str( D['login'] ),
				str( D['description'] )
			)
		SC.transact( { 'gas': 30000 } )
		local_data['ULog']['Admins'].append( address )
		print ( TC(k), "Message ( OLog->AddAdmin' ): transaction initiated!" )
	
	@classmethod
	def AddUser(cls, address,*, D):
		SC = cls.connect_con.functions.AddUser(
				Web3.toChecksumAddress( address ),
				int( D['createtime'][0] ), int( D['createtime'][1] ), int( D['createtime'][2] ), int( D['createtime'][3] ), int( D['createtime'][4] ), int( D['createtime'][5] ),
				int ( 2 ),
				str( D['login'] ),
				str( D['description'] )
			)
		SC.transact( { 'gas': 30000 } )
		local_data['ULog']['Users'].append( address )
		print ( TC(k), "Message ( OLog->AddUser' ): transaction initiated!" )
	
	@classmethod
	def AddUserFromBD(cls):
		datas = cls.DataFromBDUInfo()
		#only one (1) sysadmin-address for SCC
		for data in datas[0:1]:
			cls.AddSysadmin(Address(), D=data)
			time.sleep(ts)
		#only ten (10) addmins-addresses for SCC
		for data in datas[1:10]:
			cls.AddAdmin(Address(), D=data)
			time.sleep(ts)
		#uncount users-addresses for SCC
		for data in datas[10:]:
			cls.AddUser(Address(), D=data)
			time.sleep(ts)
		print ( TC(k), "Message ( OLog->AddUserFromBD' ): operation comleted!" )
	
	@classmethod
	def GetUserTypes(cls, address):
		i = 0
		types = []
		while True:
			SC = cls.connect_con.functions.GetType(Web3.toChecksumAddress( address ), i)
			time.sleep(ts)
			i += 1
			request = SC.call()
			if request[0]:
				types.append( str(request[2:]) )
				continue
			else:
				break
		return types
					
	@classmethod
	def GetUserActions(cls, address):
		i = 0
		actions = []
		while True:
			SC = cls.connect_con.functions.GetAction(Web3.toChecksumAddress( address ), i)
			time.sleep(ts)
			i += 1
			request = SC.call()
			if request[0]:
				actions[0].append( str(request[2:]) )
				continue
			else:
				break
		return actions
	
	@classmethod
	def GetUserInformations(cls, address):
		i = 0
		informs = []
		while True:
			SC = cls.connect_con.functions.GetInfo(Web3.toChecksumAddress( address ), i)
			time.sleep(ts)
			i += 1
			request = SC.call()
			if request[0]:
				informs.append( str(request[2:]) )
				continue
			else:
				break
		return informs
		
	@classmethod
	def GetUserKeff(cls, address):
		SC = cls.connect_con.functions.GetKeff( Web3.toChecksumAddress( address ) )
		time.sleep(ts)
		return SC.call()[2:]
	
	@classmethod
	def GetUserBalance(cls, address):
		SC = cls.connect_con.functions.GetBalance( Web3.toChecksumAddress( address ) )
		time.sleep(ts)
		return SC.call()[2:]
		
	@classmethod
	def GetUserGroup(cls, address):
		i = 0
		groups = []
		while True:
			SC = cls.connect_con.functions.GetGroup(Web3.toChecksumAddress( address ), i)
			time.sleep(ts)
			i += 1
			request = SC.call()
			if request[0]:
				groups.append( str( GLog.GetGroupByAddress(str(request[2])) ) )
				continue
			else:
				break
		return groups
	
	@classmethod
	def GetUserOrg(cls, address):
		i = 0
		orgs = []
		while True:
			SC = cls.connect_con.functions.GetOrg(Web3.toChecksumAddress( address ), i)
			time.sleep(ts)
			i += 1
			request = SC.call()
			if request[0]:
				orgs.append( str( OLog.GetOrgsByAddress(str(request[2])) ) )
				continue
			else:
				break
		return orgs
	
	@classmethod
	def GetInfoAboutUser(cls, address):
		return "User-accout = {addr}:\n\tTypes: {T} \n\tActions: {A} \n\tInformations: {I} \n\t{G}Groups: \n\t{O}Orgs: ".format(
					addr = address,
					T = cls.GetUserTypes(address),
					A = cls.GetUserActions(address),
					I = cls.GetUserInformations(address),
					G = cls.GetUserGroup(address),
					O = cls.GetUserOrg(address)
					)

	@classmethod
	def PrintAllUsers(cls):
		print('System-users')
		for i, address in enumerate(local_data['ULog']['Sysadmins']):
			print ("{})\t{}".format(i, cls.GetInfoAboutUser(address)) )
			
		print('Admins-users')
		for i, address in enumerate(local_data['ULog']['Admins']):
			print ("{})\t{}".format(i, cls.GetInfoAboutUser(address)) )
			
		print('Users-users')
		for i, address in enumerate(local_data['ULog']['Users']):
			print ("{})\t{}".format(i, cls.GetInfoAboutUser(address)) )
		
		
class TLog:
	#TLog-controller
	contract_abi  = GetABI(path_to_file, 'TLog')
	contract_bin  = GetBIN(path_to_file, 'TLog')
	contract_add = Web3.toChecksumAddress("0x2e8F255E9e9b5e239f4748a886b2611B0d14a9A3")
	connect_con = web3.eth.contract(address=contract_add, abi=contract_abi)
	
	def TCP(keff, node_count, priven_time):
		return keff * node_count * priven_time
	
	def TCA(keff, node_count, actual_time):
		return keff * node_count * actual_time
	
	@classmethod
	def DataFromBDTInfo(cls):
		res = []
		cur = db.cursor()
		cur.execute(
"""
SELECT --TInfo
		T.tid as "ID",
		U.userid as "owner",
		T.taskname as "name",
		T.nproc as "nroc",
		T.indate as "initial"
	FROM {}.tasks as T
	INNER JOIN public.users as U on T.userid = U.userid;""".format(shem) )
		row = cur.fetchone()
		while row:
			res.append( {"ID" : row[0], "owner" : int(row[1]) , "name" : str(row[2]).strip(), "nproc" : str(row[3]).strip(), "initial" : Daetime(str(row[4]).strip()) } )
			row = cur.fetchone()
		return res

	@classmethod
	def AddTask(cls, address, *, D):
		SC = cls.connect_con.functions.AddTask(
				Web3.toChecksumAddress( address ),
				int( D['initial'][0] ), int( D['initial'][1] ), int( D['initial'][2] ), int( D['initial'][3] ), int( D['initial'][4] ), int( D['initial'][5] ),
				str( D['name'] ),
				int( D['nproc'] ),
				int( 100 ), #необходимо чтобы пользователи-инициаторы буквально были в блокчейн-БД
				int( 0 )    #необходимо чтобы задание прошло полный путь - было в блокчейн-БД
			)
		SC.transact( { 'gas': 30000 } )
		local_data['TLog'].append( address )
		print ( TC(k), "Message ( TLog->AddTask' ): transaction initiated!" )

	@classmethod
	def AddTaskFromBD(cls):
		for data in cls.DataFromBDTInfo():
			cls.AddTask( Address(), D=data)
			time.sleep(ts)
		print ( TC(k), "Message ( TLog->AddTaskFromBD ): succressfully added!" )
	
	@classmethod
	def AddStatus(cls, address,*, D):
		SC = cls.connect_con.functions.AddStatus(
				Web3.toChecksumAddress( address ),
				int( D['time'][0] ), int( D['time'][1] ), int( D['time'][2] ), int( D['time'][3] ), int( D['time'][4] ), int( D['time'][5] ),
				int( D['status'] ) )
		SC.transact( { 'gas': 30000 } )
		local_data['TLog'].append( address )
		print ( TC(k), "Message ( TLog->AddStatus' ): transaction initiated -> task's status update to {}!".format(D['status']) )
		
	@classmethod
	def AddTaskStatus(cls):
		for address in local_data['TLog']:
			start_date = [random.randint(18, 19), random.randint(1, 12), random.randint(0, 28), random.randint(0, 24), random.randint(0, 59), random.randint(0, 59)]
			data = {
				'GQT_push' 			: {'time' : GetRandomDate(start_date, random.randint(1, 10)), 				'status' : 1}, #0
				'LQT_push' 			: {'time' : GetRandomDate(start_date, random.randint(10, 20)), 				'status' : 3}, #2
				'LQT_add' 			: {'time' : GetRandomDate(start_date, random.randint(20, 30)), 				'status' : 5}, #4
				'GQT_pop' 			: {'time' : GetRandomDate(start_date, random.randint(20, 30)), 				'status' : 2}, #1
				'LQT_start_load' 	: {'time' : GetRandomDate(start_date, random.randint(30, 40)), 				'status' : 7}, #6
				'LQT_stop_load' 	: {'time' : GetRandomDate(start_date, random.randint(40, 1000)), 			'status' : 8}, #7
				'alloc_res' 		: {'time' : GetRandomDate(start_date, random.randint(1000, 1010)), 			'status' : 9}, #8
				'releas_res' 		: {'time' : GetRandomDate(start_date, random.randint(1000000, 10000000)), 	'status' : 10},#9
				'LQT_rm' 			: {'time' : GetRandomDate(start_date, random.randint(10000005, 10000010)), 	'status' : 6}, #5
				'LQP_pop' 			: {'time' : GetRandomDate(start_date, random.randint(10000000, 10000005)), 	'status' : 4}  #3
				}
			for key in data.keys():
				cls.AddStatus(address, D=data[key])
		print ( TC(k), "Message ( TLog->AddStatusFromBDToTaskINBlockcain' ): succressfully added!" )

	@classmethod
	def GetTaskStatus(cls, address):
		i = 0
		infos = []
		while True:
			SC = cls.connect_con.functions.GetStatus(Web3.toChecksumAddress( address ), i)
			request = SC.call()
			i += 1
			if request[0]:
				infos.append(request[2:])
				continue
			else:
				break
		return infos

	@classmethod
	def GetTaskInfo(cls, address):
		SC = cls.connect_con.functions.GetLastInfos( Web3.toChecksumAddress( address ))
		return SC.call()[2:]

	@classmethod
	def GetTaskByAddress(cls, address):
		return "Task-account = {adr}\n\tStatus: {S}\n\tInformations: {I}".format(
			adr = address,
			S = cls.GetTaskStatus(address),
			I = cls.GetTaskInfo(address)
			)

	@classmethod
	def PrintAllTasksAndItStates(cls):
		for address in local_data['TLog']:
			print(cls.GetTaskByAddress(address))
		print ( TC(k), "Message ( TLog->PrintAllTasksAndItStates' ): succressfully printed!" )



def DBLoad():
	OLog.AddOrgsFromDB()
	GLog.AddGropFromDB()
	ULog.AddUserFromBD()
	TLog.AddTaskFromBD()
	TLog.AddTaskStatus()
	

if __name__ == '__main__':
	ControllerInit()
	local_data = DumpOpen()
	#---
	#Deploy()
	DBLoad()
	
	#print (local_data)
	#---
	ControllerClose()
	
	
