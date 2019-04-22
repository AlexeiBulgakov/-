pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";
import "./CNLog.sol";

contract CMLog {
    
    mapping ( address => CM.CMStat[] ) private _cms_stats;
    
    mapping ( address => CM.CMInfo[] ) private _cms_infos;
    
    CNLog private _CN;
    
    
    constructor(address cn_address) public { _CN = CNLog(cn_address); }
    
    
    function DecomposeS(CM.CMStat memory status) private pure returns (string memory, uint8, uint8, uint8, uint8, CM.CMStatus) {
        return (Skills.DateToStr(status.dt.mm, status.dt.mm, status.dt.dd, status.dt.hh, status.dt.m, status.dt.s), status.CPU, status.RAM, status.SDD, status.NET, status.stat);
    }
    
    function DecomposeI (CM.CMInfo memory info) private pure returns (string memory, address, string memory, string memory, string memory, string memory) {
        return (Skills.DateToStr(info.dt.yyyy, info.dt.mm, info.dt.dd, info.dt.hh, info.dt.m, info.dt.s), info.owner, info.CPU_info, info.RAM_info, info.SDD_info, info.NET_info);
    }
    
    
    function GetS(address cm_add, uint256 i) private view returns (string memory, uint8, uint8, uint8, uint8, CM.CMStatus) {
        return DecomposeS(_cms_stats[cm_add][i]);
    }
    
    function GetI(address cm_add, uint256 i) private view returns (string memory, address, string memory, string memory, string memory, string memory) {
        return DecomposeI(_cms_infos[cm_add][i]);
    }
    
    
    function AddS(address cm_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, uint8 cpu, uint8 ram, uint8 sdd, uint8 net, CM.CMStatus stat) private {
        _cms_stats[cm_add].push(CM.CMStat(DT.DateTime(yyyy, mm, dd, hh, m, s), cpu, ram, sdd, net, stat));
    }
    
    function AddI(address cm_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory cpu_info, string memory ram_info, string memory sdd_info, string memory net_info) private {
        _cms_infos[cm_add].push(CM.CMInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), owner, cpu_info, ram_info, sdd_info, net_info));
    }
    
    
    function Check(address cm_add) public view returns (bool) { 
        if ((_cms_stats[cm_add].length > 0)  && (_cms_infos[cm_add].length > 0))  return true;
        else return false; 
    }
    
    
    function CountOfStatus(address cm_add) public view returns (uint256) {
        require(Check(cm_add), "Error ( CMLog->CountOfStatus ): CM by address (arg1) is't exist!");
        return _cms_stats[cm_add].length;
    }
    
    function CountOfInformations(address cm_add) public view returns (uint256) {
        require(Check(cm_add), "Error ( CMLog->CountOfInformations ): CM by address (arg1) is't exist!");
        return _cms_infos[cm_add].length;
    }
    
    
    function AddInStats(address cm_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, uint8 cpu, uint8 ram, uint8 sdd, uint8 net, CM.CMStatus stat) public {
        require(Check(cm_add), "Error ( CMLog->AddInStats ): CM by address (arg1) is't exist!");
        AddS(cm_add, yyyy, mm, dd, hh, m, s, cpu, ram, sdd, net, stat);
    }
    
    function AddInInfos(address cm_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory cpu_info, string memory ram_info, string memory sdd_info, string memory net_info) public {
        require(Check(cm_add), "Error ( CMLog->AddInInfos ): CM by address (arg1) is't exist!");
        require(_CN.Check(owner), "Error ( CMLog->AddInInfos ): SN by address (arg8) is't exist!");
        AddI(cm_add, yyyy, mm, dd, hh, m, s, owner, cpu_info, ram_info, sdd_info, net_info);
    }

    function AddCM(address cm_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory cpu_info, string memory ram_info, string memory sdd_info, string memory net_info, CM.CMStatus stat) public {
        require(!Check(cm_add), "Error ( CMLog->AddCM ): CM by address (arg1) is allready exist!");
        require(_CN.Check(owner), "Error ( CMLog->AddCM ): SN by address (arg8) is't exist!");
        AddS(cm_add, yyyy, mm, dd, hh, m, s, 0, 0, 0, 0, stat);
        AddI(cm_add, yyyy, mm, dd, hh, m, s, owner, cpu_info, ram_info, sdd_info, net_info);
    }
    
    
    function GetStatus (address cm_add, uint256 i) public view returns (string memory, uint8, uint8, uint8, uint8, CM.CMStatus) {
        require(Check(cm_add), "Error ( CMLog->GetStatus ): CM by address (arg1) is't exist!");
        require(i < CountOfStatus(cm_add), "Error ( CMLog->GetStatus ): out of range!");
        return GetS(cm_add, i);
    }
    
    function GetInformation (uint256 i, address cm_add) public view returns (string memory, address, string memory, string memory, string memory, string memory) {
        require(Check(cm_add), "Error ( CMLog->GetInformation ): CM by address (arg1) is't exist!");
        require(i < CountOfInformations(cm_add), "Error ( CMLog->GetInformation ): out of range!");
        return GetI(cm_add, i);
    }
    
    
    function GetLastStatus (address cm_add) public view returns (string memory, uint8, uint8, uint8, uint8, CM.CMStatus) {
        require(Check(cm_add), "Error ( CMLog->GetLastStatus ): CM by address (arg1) is't exist!");
        return GetS(cm_add, CountOfStatus(cm_add) - 1);
    }

    function GetLastInformation (address cm_add) public view returns (string memory, address, string memory, string memory, string memory, string memory) {
        require(Check(cm_add), "Error ( CMLog->GetLastInformation ): CM by address (arg1) is't exist!");
        return GetI(cm_add, CountOfInformations(cm_add) - 1);
    }
    
}//CMLog
