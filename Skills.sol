pragma solidity >= 0.4.0 < 0.6.0;

import "./DataTypes.sol";

library Skills {
    
    function UIntToStr(uint256 _i) public pure returns(string memory) {
        if (_i == 0) {
            return "0";
        }
        
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        
        return string(bstr);
    }
    
    function StrConcat(string memory str1, string memory str2) public pure returns(string memory) {
        bytes memory b_str1 = bytes(str1);
        bytes memory b_str2 = bytes(str2);
        bytes memory res_b  = bytes(new string(b_str1.length + b_str2.length));
        
        uint256 i = 0;
        
        for (uint256 j = 0; j < b_str1.length; ++j) {
            res_b[i++] = b_str1[j];
        }
        
        for (uint256 j = 0; j < b_str2.length; ++j) {
            res_b[i++] = b_str2[j];
        }
        
        return string(res_b);
    }
    
    function AddToStr(address x) public pure returns (string memory) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }
    
    function CheckAddress (address add) public pure returns (bool) {
        if (add != address( 0x0000000000000000000000000000000000000000 )) return true;
        else return false;
    }
    
    function DateToStr(uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s) public pure returns (string memory) {
        StrConcat(StrConcat(StrConcat(StrConcat(StrConcat(
            StrConcat("", UIntToStr(dd)),
            StrConcat(".", UIntToStr(mm))),
            StrConcat(".", UIntToStr(yyyy))),
            StrConcat(" ", UIntToStr(hh))),
            StrConcat(":", UIntToStr(m))),
            StrConcat(":", UIntToStr(s)));
    }
    
}//Skills
