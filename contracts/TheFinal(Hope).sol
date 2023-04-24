// Specifies the version of Solidity, using semantic versioning.
// Learn more: https://solidity.readthedocs.io/en/v0.5.10/layout-of-source-files.html#pragma
pragma solidity ^0.8.1;

pragma experimental ABIEncoderV2;

contract VaccineRegistry {
  
  struct Vaccine {
    string name;
    uint256 date;
    address doctor;
    string doctorName;
  }
  
  mapping (address => Vaccine[]) public patientVaccines;
  mapping (address => bool) public verifiedDoctors;
  mapping (address => string) public doctorNames;

  modifier onlyAdmin() {
    require(msg.sender == admin, "Only admin can call this function");
    _;
  }
  
  address admin;
  
  constructor() {
    admin = msg.sender;
  }
  
  function addVaccine(address patient, string memory name, uint256 date) public {
    require(verifiedDoctors[msg.sender], "Doctor must be verified to add vaccines");
    patientVaccines[patient].push(Vaccine(name, date, msg.sender, doctorNames[msg.sender]));
  }
  
  function getPatientVaccines(address patient) public view returns (Vaccine[] memory) {
    Vaccine[] memory vaccines = patientVaccines[patient];
    for (uint256 i = 0; i < vaccines.length; i++) {
      vaccines[i].doctorName = getDoctorName(vaccines[i].doctor);
    }
    return vaccines;
  }
  
  function addAndVerifyDoctor(address doctor, string memory name) public onlyAdmin {
    doctorNames[doctor] = name;
    verifiedDoctors[doctor] = true;
  }
  
  function getDoctorName(address doctor) private view returns (string memory) {
    return doctorNames[doctor];
  }

  function isVerified(address doctor) public view returns (bool) {
    return verifiedDoctors[doctor];
  }
  
}
