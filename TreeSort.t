% % Name:
% %
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setscreen ("graphics:800;1200")
var YourFullName : string := "Zoravur Singh"

%  File students.rec was written using the following record structure
%  It must be used to input records from the file.
type StudentRecType :
    record
	studentNum : int
	surName : string (10)
	firstName : string (10)
	average : real
    end record

%  A student node type.
%  Must be used for implementing a binary tree.
type StudentNodeType :
    record
	studentNum : int
	surName : string (10)
	firstName : string (10)
	average : real
	ptrLess, ptrGtr : ^StudentNodeType
    end record

%  Declare a root to the list of StudentNodeType
var root : ^StudentNodeType := nil

fcn isEmpty : boolean

    if root = nil then
	result true
    else
	result false
    end if

end isEmpty


% diplays student is alpha order Recursive Method
%
proc RecursiveDisplay (student : ^StudentNodeType)
    if student -> ptrLess not= nil then %if there are more pointers to the left, then keep reading down the left
	RecursiveDisplay (student -> ptrLess)
    end if
    put "Student Number: ", student -> studentNum
    put "Student Surname: ", student -> surName
    put "Student First Name :", student -> firstName
    put "Student Average :", student -> average
    put ""
    if student -> ptrGtr not= nil then
	RecursiveDisplay (student -> ptrGtr) %if there is no more on the left, but there are more on the right, keep reading down the right
    end if
end RecursiveDisplay

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
proc displayAllTreeRecords %%procedure just to check if the tree is empty
    if isEmpty then
	put "The tree is empty"
    else
	RecursiveDisplay (root)
    end if
end displayAllTreeRecords

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adds a new record to the tree
% ----requires parameters
proc addNewStudentToTree (var treeRoot : ^StudentNodeType, NewNode : ^StudentNodeType)

    if (isEmpty) then
	% root = nil same as isEmpty
	root := NewNode
    elsif (treeRoot = nil) then
	% treeRoot is nil
	treeRoot := NewNode
    elsif (NewNode -> studentNum < treeRoot -> studentNum) then
	% NewNode -> studentNum < treeRoot -> studentNum
	addNewStudentToTree (treeRoot -> ptrLess, NewNode)
    else
	% NewNode -> studentNum > treeRoot -> studentNum
	addNewStudentToTree (treeRoot -> ptrGtr, NewNode)
    end if


end addNewStudentToTree

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loads data from a binary/record file and calls addNewStudentToTree to build the
% binary search tree
proc laodTreeFromFile

    var stream : int := 0
    open : stream, "students.rec", read

    var r : StudentRecType
    var rNode : ^StudentNodeType


    loop
	% input data from the record file
	exit when eof (stream)
	read : stream, r

	% instantiate a NEW node
	new rNode

	% set the data in the new node variable
	rNode -> studentNum := r.studentNum
	rNode -> surName := r.surName
	rNode -> firstName := r.firstName
	rNode -> average := r.average
	% don't forget to set the member pointers
	rNode -> ptrLess := nil
	rNode -> ptrGtr := nil


	% insert or add the node to the tree
	% Call procedure 'addNewStudentToTree'
	%  'addNewStudentToTree' will require parameters
	addNewStudentToTree (root, rNode)

    end loop


    close : stream


end laodTreeFromFile


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcn findStudent (id : int, ptr : ^StudentNodeType) : ^StudentNodeType

    if ptr = nil then
	result nil
    end if

    var res : ^StudentNodeType := nil
    if id = ptr -> studentNum then
	result ptr
    end if

    if ptr -> ptrLess not= nil and id < ptr -> studentNum then
	res := findStudent (id, ptr -> ptrLess)
    elsif ptr -> ptrGtr not= nil then
	res := findStudent (id, ptr -> ptrGtr)
    end if
    result res

end findStudent

fcn findParent (id : int, ptr, parent : ^StudentNodeType) : ^StudentNodeType

    var res : ^StudentNodeType := nil
    if id = ptr -> studentNum then
	result parent
    end if

    if ptr -> ptrLess not= nil and id < ptr -> studentNum then
	res := findParent (id, ptr -> ptrLess, ptr)
    elsif ptr -> ptrGtr not= nil then
	res := findParent (id, ptr -> ptrGtr, ptr)
    end if
    result res

end findParent

proc findStudentAndDisplayStudentRecord (StudentIdKey : int)
    var ptr : ^StudentNodeType := findStudent (StudentIdKey, root)

    if ptr = nil then
	put "Student ", StudentIdKey, " not found"
	return
    end if


    put "Student Number: ", ptr -> studentNum
    put "Student Surname: ", ptr -> surName
    put "Student First Name :", ptr -> firstName
    put "Student Average :", ptr -> average
    put ""
    return
end findStudentAndDisplayStudentRecord

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
proc removeStudentRecordFromTree (StudentIdKey : int)
    var ptr : ^StudentNodeType := findStudent (StudentIdKey, root)

    if ptr = nil then
	put "Student ", StudentIdKey, " not found"
	return
    end if

    if ptr = root then
	root := ptr -> ptrLess
	addNewStudentToTree (root, ptr -> ptrGtr)
	return
    end if

    %Delete parwent's connection to target
    var parent : ^StudentNodeType := findParent (StudentIdKey, root, nil)
    if parent -> ptrLess = ptr then
	parent -> ptrLess := nil
    else
	parent -> ptrGtr := nil
    end if

    
    if ptr -> ptrLess not= nil then
	addNewStudentToTree (parent, ptr -> ptrLess)
	ptr -> ptrLess := nil
    end if
    
    if ptr -> ptrGtr not= nil then
	addNewStudentToTree (parent, ptr -> ptrGtr)
	ptr -> ptrGtr := nil
    end if
    
    
    %burn everything
    ptr := nil

end removeStudentRecordFromTree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  MIAN PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var ch : string (1)
colorback (black)
color (white)

loop
    cls

    put "\n        BINARY TREE by  ", YourFullName
    put "\n=============================================\n"

    put "  1. Add a new student to the tree"
    put "  2. Load tree from record file"
    put "  3. List all records in the tree"
    put "  4. List a specific student"
    put "  5. Delete a student"
    put "  9. Exit"

    put "\n=============================================\n"

    put "  Enter your selection:  " ..
    getch (ch)
    put "\n\n"
    case (ch) of
	label "1" :
	    var NewNode : ^StudentNodeType
	    new NewNode

	    NewNode -> ptrLess := nil
	    NewNode -> ptrGtr := nil

	    put "Enter student number: " ..
	    get NewNode -> studentNum
	    put "Enter last name: " ..
	    get NewNode -> surName : *
	    put "Enter first name: " ..
	    get NewNode -> firstName : *
	    put "Enter average: " ..
	    get NewNode -> average

	    addNewStudentToTree (root, NewNode)
	label "2" :
	    laodTreeFromFile
	label "3" :
	    displayAllTreeRecords
	label "4" :
	    var StudentIdKey : int
	    put "\n Enter student ID (Student Number):  " ..
	    get StudentIdKey
	    findStudentAndDisplayStudentRecord (StudentIdKey)
	label "5" :
	    var StudentIdKey : int
	    put "\n Enter student ID (Student Number):  " ..
	    get StudentIdKey
	    removeStudentRecordFromTree (StudentIdKey)
	label "9" :
	    exit
	label :

	    put "\n\n   Don't understand - ", ch, " - Try again."

    end case
    put "\n\n     Enter any key to continue...." ..
    getch (ch)
end loop
