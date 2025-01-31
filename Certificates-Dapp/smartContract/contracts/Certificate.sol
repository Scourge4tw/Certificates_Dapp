// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract BirthCertificate {
    address public owner;
    uint256 public birthId = 25000;
    
    struct BirthCertif {
        uint256 birthId;
        string name;
        string fatherName;
        string motherName;
        string dob;
        string sex;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the admin");
        _;
    }

    mapping(bytes32 => BirthCertif) public birthCandidate;
    mapping(uint256 => bytes32) public birthNumber;
    mapping(bytes32 => bool) public check;

    event CertificateIssued(
        uint256 birthId,
        string dob,
        string name,
        string fatherName,
        string motherName,
        string sex
    );

    function issueBirthCertificate(
        string memory dob,
        string memory name,
        string memory fatherName,
        string memory motherName,
        string memory sex
    ) external onlyOwner returns (uint256) {
        bytes32 salt = bytes32(uint256(keccak256(abi.encodePacked(msg.sender))));
        bytes32 certificateId = bytes32(uint256(keccak256(abi.encodePacked(salt, dob, name, fatherName, motherName, sex))));
        require(!check[certificateId], "Certificate with the same details already issued");
        check[certificateId] = true;

        birthCandidate[certificateId] = BirthCertif(
            birthId,
            name,
            fatherName,
            motherName,
            dob,
            sex
        );
        emit CertificateIssued(birthId, dob, name, fatherName, motherName, sex);
        birthNumber[birthId] = certificateId;
        birthId++;

        return birthId - 1;
    }

    function getData(bytes32 _id) view public returns (
        uint256,
        string memory ,
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        require(check[_id], "Not a valid ID");
        BirthCertif memory data = birthCandidate[_id];
        return (data.birthId, data.name, data.fatherName, data.motherName, data.dob, data.sex);
    }

    function checkId(uint256 _id) view public returns (bytes32) {
        return birthNumber[_id];
    }
}
