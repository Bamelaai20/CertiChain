// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UniversityCertificate {

    // Define the structure for student certificates
    struct Certificate {
        bool passedAllSubjects;
        bool goodAttendance;
        bool allFeesPaid;
        uint256 issueDate;
        bool isVerified;
    }

    // Define a mapping from student address to their certificate
    mapping(address => Certificate) public certificates;

    // Event to be emitted when a certificate is issued
    event CertificateIssued(address indexed student, uint256 issueDate);

    // Event to be emitted when a certificate is verified
    event CertificateVerified(address indexed student, bool verified);

    // University contract address (only this address can issue certificates)
    address public university;

    constructor() {
        university = msg.sender;
    }

    // Modifier to restrict access to university functions
    modifier onlyUniversity() {
        require(msg.sender == university, "Only the university can perform this action.");
        _;
    }

    // Function to issue a certificate to a student
    function issueCertificate(
        address student,
        bool passedAllSubjects,
        bool goodAttendance,
        bool allFeesPaid
    ) external onlyUniversity {
        certificates[student] = Certificate({
            passedAllSubjects: passedAllSubjects,
            goodAttendance: goodAttendance,
            allFeesPaid: allFeesPaid,
            issueDate: block.timestamp,
            isVerified: false
        });

        emit CertificateIssued(student, block.timestamp);
    }

    // Function to verify a certificate
    function verifyCertificate(address student) external {
        Certificate storage cert = certificates[student];
        require(cert.issueDate > 0, "Certificate does not exist.");

        bool isVerified = cert.passedAllSubjects &&
                          cert.goodAttendance &&
                          cert.allFeesPaid;

        cert.isVerified = isVerified;

        emit CertificateVerified(student, isVerified);
    }

    // Function to retrieve certificate details
    function getCertificate(address student) external view returns (
        bool passedAllSubjects,
        bool goodAttendance,
        bool allFeesPaid,
        uint256 issueDate,
        bool isVerified
    ) {
        Certificate storage cert = certificates[student];
        return (
            cert.passedAllSubjects,
            cert.goodAttendance,
            cert.allFeesPaid,
            cert.issueDate,
            cert.isVerified
        );
    }
}