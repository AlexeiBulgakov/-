pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./SCCLog.sol";
import "./Skills.sol";

contract CNLog {
    
    mapping ( address => CN.CNStat[] ) private _cns_stats;  //CNs's status
    
    mapping ( address => CN.CNInfo[] ) private _cns_infos;  //CNs's infornations
    
    SCCLog private _SCC;
    
    
    constructor (address scc_address) public { _SCC = SCCLog(scc_address); }
    
    
    function DecomposeS(CN.CNStat memory status) private pure returns (string memory, CN.CNStatus) {
        return (Skills.DateToStr(status.dt.mm, status.dt.mm, status.dt.dd, status.dt.hh, status.dt.m, status.dt.s), status.stat);
    }
    
    function DecomposeI (CN.CNInfo memory info) private pure returns (string memory, address, string memory, string memory, string memory, uint32) {
        return (Skills.DateToStr(info.dt.yyyy, info.dt.mm, info.dt.dd, info.dt.hh, info.dt.m, info.dt.s), info.owner, info.name, info.host, info.port, info.cCMs);
    }
    
    
    function GetS(address cn_add, uint256 i) private view returns (string memory, CN.CNStatus) {
        return DecomposeS(_cns_stats[cn_add][i]);
    }
    
    function GetI(address cn_add, uint256 i) private view returns (string memory, address, string memory, string memory, string memory, uint32) {
        return DecomposeI(_cns_infos[cn_add][i]);
    }
    
    
    function AddS(address cn_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, CN.CNStatus stat) private {
        _cns_stats[cn_add].push(CN.CNStat(DT.DateTime(yyyy, mm, dd, hh, m, s), stat));
    }
    
    function AddI(address cn_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory name, string memory addr, string memory desc, uint32 cCNs) private {
        _cns_infos[cn_add].push(CN.CNInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), owner, name, addr, desc, cCNs));
    }
   
    
    function Check(address cn_add) private view returns (bool) {
        if ((_cns_stats[cn_add].length > 0)  && (_cns_infos[cn_add].length > 0))  return true;
        else return false;
    }
    
    
    function CountOfStatus(address cn_add) public view returns (uint256) {
        require(Check(cn_add), "Error ( CNLog->CountOfStatus ): CN by address (arg1) is't exist!");
        return _cns_stats[cn_add].length;
    }
    
    function CountOfInformations(address cn_add) public view returns (uint256) {
        require(Check(cn_add), "Error ( CNLog->CountOfInformations ): CN by address (arg1) is't exist!");
        return _cns_infos[cn_add].length;
    }
    
    
    function AddInStats(address cn_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, CN.CNStatus stat) public {
        require(Check(cn_add), "Error ( CNLog->AddInStats ): CN by address (arg1) is't exist!");
        AddS(cn_add, yyyy, mm, dd, hh, m, s, stat);
    }
    
    function AddInInfos(address cn_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory name, string memory host, string memory port, uint32 cCMs) public {
        require(Check(cn_add), "Error ( CNLog->AddInInfos ): CN by address (arg1) is't exist!");
        require(_SCC.Check(owner), "Error ( CNLog->AddInInfos ): SCC by address (arg8) is't exist!");
        AddI(cn_add, yyyy, mm, dd, hh, m, s, owner, name, host, port, cCMs);
    }

    function AddCN(address cn_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, address owner, string memory name, string memory host, string memory port, uint8 cCMs, CN.CNStatus stat) public {
        require(!Check(cn_add), "Error ( CNLog->AddCN ): CN by address (arg1) is allready exist!");
        require(_SCC.Check(owner), "Error ( CNLog->AddCN ): SCC by address (arg8) is't exist!");
        AddS(cn_add, yyyy, mm, dd, hh, m, s, stat);
        AddI(cn_add, yyyy, mm, dd, hh, m, s, owner, name, host, port, cCMs);
    }
    
    
    function GetStatus (address cn_add, uint256 i) public view returns (string memory, CN.CNStatus) {
        require(Check(cn_add), "Error ( CNLog->GetStatus ): CN by address (arg1) is't exist!");
        require(i < CountOfStatus(cn_add), "Error ( CNLog->GetStatus ): out of range!");
        return GetS(cn_add, i);
    }
    
    function GetInformation (address cn_add, uint256 i) public view returns (string memory, address, string memory, string memory, string memory, uint32) {
        require(Check(cn_add), "Error ( CNLog->GetInformation ): CN by address (arg1) is't exist!");
        require(i < CountOfInformations(cn_add), "Error ( CNLog->GetInformation ): out of range!");
        return GetI(cn_add, i);
    }
    
    
    function GetLastStatus (address cn_add) public view returns (string memory, CN.CNStatus) {
        require(Check(cn_add), "Error ( CNLog->GetStatus ): CN by address (arg1) is't exist!");
        return GetS(cn_add, CountOfStatus(cn_add) - 1);
    }
    
    function GetLastInformation (address cn_add) public view returns (string memory, address, string memory, string memory, string memory, uint32) {
        require(Check(cn_add), "Error ( CNLog->GetInformation ): CN by address (arg1) is't exist!");
        return GetI(cn_add, CountOfInformations(cn_add) - 1);
    }
    
}//CNLog
