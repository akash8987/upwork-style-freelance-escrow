// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title FreelanceEscrow
 * @dev Handles secure payments and milestone releases for freelancers.
 */
contract FreelanceEscrow is ReentrancyGuard {
    enum State { ACTIVE, DISPUTED, RESOLVED, COMPLETED }

    struct Job {
        address client;
        address freelancer;
        uint256 totalAmount;
        uint256 releasedAmount;
        State state;
    }

    mapping(uint256 => Job) public jobs;
    uint256 public jobCount;

    event JobCreated(uint256 indexed id, address indexed client, address indexed freelancer);
    event FundsReleased(uint256 indexed id, uint256 amount);

    /**
     * @dev Client creates a job and locks the full project fee.
     */
    function createJob(address _freelancer) external payable {
        require(msg.value > 0, "Must fund the escrow");
        
        jobs[jobCount] = Job({
            client: msg.sender,
            freelancer: _freelancer,
            totalAmount: msg.value,
            releasedAmount: 0,
            state: State.ACTIVE
        });

        emit JobCreated(jobCount++, msg.sender, _freelancer);
    }

    /**
     * @dev Client releases a portion of the funds (a milestone).
     */
    function releaseMilestone(uint256 _jobId, uint256 _amount) external nonReentrant {
        Job storage j = jobs[_jobId];
        require(msg.sender == j.client, "Only client can release");
        require(j.state == State.ACTIVE, "Job not active");
        require(j.releasedAmount + _amount <= j.totalAmount, "Exceeds total");

        j.releasedAmount += _amount;
        payable(j.freelancer).transfer(_amount);

        if (j.releasedAmount == j.totalAmount) {
            j.state = State.COMPLETED;
        }

        emit FundsReleased(_jobId, _amount);
    }

    function dispute(uint256 _jobId) external {
        Job storage j = jobs[_jobId];
        require(msg.sender == j.client || msg.sender == j.freelancer, "Not a party");
        j.state = State.DISPUTED;
    }
}
