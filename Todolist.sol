// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    struct Task {
        string description;
        bool completed;
    }

    Task[] public tasks;

    function addTask(string memory _description) public {
        tasks.push(Task(_description, false));
    }

    function toggleTaskCompletion(uint _taskId) public {
        Task storage task = tasks[_taskId];
        task.completed = !task.completed;
    }

    function removeTask(uint _taskId) public {
        require(_taskId < tasks.length, "Task ID out of bounds");
        for (uint i = _taskId; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
    }

    function getTasks() public view returns (Task[] memory) {
        return tasks;
    }
}
