// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Project{
    struct Student {
        string studentName;
        bool finalYear;
        Gender gender;
        Department department;
        address studentAddress;
    }

    struct Department {
        string deptName;
        mapping (string => ProjectDetails) projectDetailData;
    }

    struct ProjectDetails {
        string studentName;
        string projectName;
        ProjectStatus projectStatus;
    }

    enum ProjectStatus {
        ongoing,
        finished
    }

    enum Gender {
        male,
        female
    }  
    
    mapping (address => Student) studentData;  
  
    function createStudentData(string memory _studentName,string memory _projectName,string memory _deptName) public {
        Student storage student = studentData[msg.sender];
        student.studentName = _studentName;
        student.finalYear = true;
        student.studentAddress = msg.sender;
        Department storage department = student.department;
        department.deptName = _deptName;
        ProjectDetails memory projectDetails;
        projectDetails.studentName = _studentName;
        projectDetails.projectName = _projectName;
        department.projectDetailData[_studentName] = projectDetails;
    }

    
    function getProjectDetails(string memory _studentName) public view returns (ProjectDetails memory){
        return studentData[msg.sender].department.projectDetailData[_studentName];
    }

    function getStudentdata(address _studentAddress) public view returns (string memory,string memory,string memory,string memory){
        string memory studentName;
        string memory gender;
        string memory department;
        string memory finalYear;
        Student storage student = studentData[_studentAddress];
        studentName = student.studentName;
        department = student.department.deptName;

        if(uint(student.gender) == 0){
            gender = "Male";
        }
        if(uint(student.gender) == 1){
            gender = "Female";
        }
        if(student.finalYear == false){
            finalYear = "Not FinalYear";
        }
        if(student.finalYear == true){
            finalYear = "FinalYear";
        }

        return (studentName,gender,department,finalYear);
    }


    function updateProjectStatus(string memory _studentName, ProjectStatus projectStatus) public OnlyStudent{
        studentData[msg.sender].department.projectDetailData[_studentName].projectStatus = projectStatus;
    }

    function updateStudentGender(Gender gender) public OnlyStudent{
        studentData[msg.sender].gender = gender;
    }

    modifier OnlyStudent(){
        require(studentData[msg.sender].studentAddress == msg.sender,"Only this student has permission");
        _;
    }

}
