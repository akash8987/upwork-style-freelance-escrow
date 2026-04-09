# Decentralized Freelance Escrow (Upwork-style)

A professional-grade implementation for the decentralized gig economy. This repository removes the 10-20% platform fees associated with traditional freelance sites. It replaces central trust with a smart contract escrow and a decentralized jury. By using milestone-based releases, it ensures that freelancers are paid for progress while protecting clients from incomplete work.

## Core Features
* **Milestone Architecture:** Contracts can be split into multiple stages (e.g., Design, Development, Testing).
* **Reputation Staking:** Freelancers stake a "Commitment Deposit" that can be slashed if they vanish, providing high-quality signaling.
* **Jury Arbitration:** If a dispute arises, a random set of staked users (Jurors) reviews the evidence and votes on the fund distribution.
* **Flat Architecture:** Single-directory layout for the Job Registry, Milestone Escrow, and Dispute Resolution.

## Logic Flow
1. **Contract:** Client hires a Freelancer and deposits 5 ETH into the Escrow.
2. **Submit:** Freelancer completes Milestone 1 and submits the work hash.
3. **Approve:** Client reviews the work and releases the milestone funds.
4. **Dispute:** If the Client is unhappy, they "Lock" the escrow. A decentralized jury is summoned to decide the split (e.g., 50% refund, 50% payout).

## Setup
1. `npm install`
2. Deploy `FreelanceEscrow.sol`.
