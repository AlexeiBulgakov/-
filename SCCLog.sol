pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";

contract SCCLog {
    
    mapping ( address => SCC.SCCStat[] ) private _sccs_stats; //SCCs's status
    
    mapping ( address => SCC.SCCInfo[] ) private _sccs_infos; //SCCs's informations
    
    
    function DecomposeS(SCC.SCCStat memory status) private pure returns (string memory, SCC.SCCStatus) {
        return (Skills.DateToStr(status.dt.mm, status.dt.mm, status.dt.dd, status.dt.hh, status.dt.m, status.dt.s), status.stat);
    }
    
    function DecomposeI(SCC.SCCInfo memory info) private pure returns (string memory, string memory, string memory, string memory, uint32) {
        return (Skills.DateToStr(info.dt.mm, info.dt.mm, info.dt.dd, info.dt.hh, info.dt.m, info.dt.s), info.name, info.addr, info.desc, info.cCNs);
    }
    
    
    function GetS(address scc_add, uint256 i) private view returns (string memory, SCC.SCCStatus) {
        return DecomposeS(_sccs_stats[scc_add][i]);
    }
    
    function GetI(address scc_add, uint256 i) private view returns (string memory, string memory, string memory, string memory, uint32) {
        return DecomposeI(_sccs_infos[scc_add][i]);
    }
    
    
    function AddS(address scc_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, SCC.SCCStatus stat) private {
        _sccs_stats[scc_add].push(SCC.SCCStat(DT.DateTime(yyyy, mm, dd, hh, m, s), stat));
    }
    
    function AddI(address scc_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory addr, string memory desc, uint32 cCNs) private {
        _sccs_infos[scc_add].push( SCC.SCCInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), name, addr, desc, cCNs) );
    }
    
    
    function Check(address scc_add) public view returns(bool) {
        if((_sccs_stats[scc_add].length > 0) && (_sccs_infos[scc_add].length > 0)) return true;
        else return false; 
    }
    
    
    function CountOfStatus(address scc_add) public view returns (uint256) {
        require(Check(scc_add), "Error ( SCCLog->CountOfStatus ): SCC by address is't exist!");
        return _sccs_infos[scc_add].length;
    }
    
    function CountOfInformations(address scc_add) public view returns (uint256) {
        require(Check(scc_add), "Error ( SCCLog->CountOfInformations ): SCC by address is't exist!");
        return _sccs_stats[scc_add].length;
    }
    
    
    function AddInStats(address scc_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, SCC.SCCStatus stat) public {
        require(Check(scc_add), "Error ( SCCLog->AddInStats ): SCC by address is't exist!");
        AddS(scc_add, yyyy, mm, dd, hh, m, s, stat);
    }
    
    function AddInInfos(address scc_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory addr, string memory desc, uint32 cCNs) public {
        require(Check(scc_add), "Error ( SCCLog->AddInInfos ): SCC by address is't exist!");
        AddI(scc_add, yyyy, mm, dd, hh, m, s, name, addr, desc, cCNs);
    }
    
    function AddSCC(address scc_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory addr, string memory desc, uint8 cCNs, SCC.SCCStatus stat) public {
        require(!Check(scc_add), "Error ( SCCLog->AddSCC ): SCC by address is allready exist!");
        AddS(scc_add, yyyy, mm, dd, hh, m, s, stat);
        AddI(scc_add, yyyy, mm, dd, hh, m, s, name, addr, desc, cCNs);
    }
    
    
    function GetStat (address scc_add, uint256 i) public view returns (string memory, SCC.SCCStatus) {
        require(Check(scc_add), "Error ( SCCLog->GetStat ): SCC by address is't exist!");
        require(i < CountOfStatus(scc_add), "Error ( SCCLog->GetStat ): out of range!");
        return GetS(scc_add, i);
    }
    
    function GetInfo (address scc_add, uint256 i) public view returns (string memory, string memory, string memory, string memory, uint32) {
        require(Check(scc_add), "Error ( SCCLog->GetInfo ): SCC by address is't exist!");
        require(i < CountOfStatus(scc_add), "Error ( SCCLog->GetInfo ): out of range!");
        return GetI(scc_add, i);
    }
    
    
    function GetLastStat (address scc_add) public view returns (string memory, SCC.SCCStatus) {
        require(Check(scc_add), "Error ( SCCLog->GetStat ): SCC by address is't exist!");
        return GetS(scc_add, CountOfStatus(scc_add) - 1);
    }
    
    function GetLastInfo (address scc_add) public view returns (string memory, string memory, string memory, string memory, uint32) {
        require(Check(scc_add), "Error ( SCCLog->GetInfo ): SCC by address is't exist!");
        return GetI(scc_add, CountOfStatus(scc_add) - 1);
    }
    
}//SCCLog
