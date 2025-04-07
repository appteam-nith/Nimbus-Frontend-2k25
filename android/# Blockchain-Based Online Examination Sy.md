# Blockchain-Based Online Examination System - Team Guide

## Introduction
Welcome to our blockchain-based online examination system. This guide explains the workflow and each team member's role so that everyone understands how the system works.

## What is This Project?
This system ensures secure, transparent, and decentralized online exams using Ethereum blockchain and IPFS. It prevents cheating, stores exam data securely, and ensures fair evaluation.

## How Does It Work? (Simple Workflow)

### 1. Exam Creation (Admin Role)
- Admin uploads exam questions (JSON format) to IPFS (decentralized storage).
- The IPFS CID (unique hash) is stored on Ethereum blockchain using a smart contract.
- Students can view the exam details but cannot modify them.

### 2. Student Submission (Student Role)
- Students submit their answers by uploading their responses to IPFS.
- The IPFS CID of the answer sheet is stored on Ethereum blockchain.
- This ensures tamper-proof and immutable submissions.

### 3. Evaluation (Admin/Teacher Role)
- The admin or teacher fetches student answers from IPFS.
- After evaluation, the score and feedback are uploaded to IPFS.
- The result CID is stored on Ethereum, making it public and unchangeable.

### 4. Result Viewing (Student Role)
- Students can retrieve their results directly from the blockchain.
- The score and feedback are stored on IPFS, ensuring transparency.

## Technologies Used
| Component  | Technology |
|------------|-------------|
| Frontend  | React.js + Ethers.js (for blockchain interactions) |
| Backend   | Golang + Geth (for blockchain communication) |
| Blockchain | Ethereum (Sepolia testnet for testing) |
| Smart Contracts | Solidity (for handling exams, submissions, and results) |
| Storage | IPFS (for decentralized question & answer storage) |
| Wallet Integration | MetaMask (for authentication) |

## Roles & Responsibilities

### UI/UX Designer (Frontend Team)
- Design a clean, easy-to-use interface for students and admins.
- Work with the React.js team to integrate MetaMask login and Ethereum transactions.
- Ensure smooth user experience for submitting and viewing results.

### Frontend Developer
- Develop the React.js interface for students and admins.
- Connect the UI with Ethereum smart contracts using Ethers.js.
- Integrate MetaMask authentication.

### Smart Contract Developer
- Write Solidity contracts to store exams, submissions, and results.
- Ensure security (only admin can create exams, only students can submit).
- Deploy contracts on the Sepolia testnet.

### Backend Developer
- Set up Golang + Geth backend to interact with smart contracts.
- Handle API requests for exam data, student submissions, and result fetching.
- Implement IPFS file storage for exam questions and answers.

### Blockchain & Security Expert
- Ensure that transactions are efficient and secure.
- Optimize gas fees and prevent smart contract vulnerabilities.
- Test contract security using tools like Remix and Hardhat.

## Example Workflow (Step-by-Step)

1. Admin uploads an exam JSON file to IPFS, gets a CID, and stores the CID in ExamContract.sol on Ethereum.
2. Student takes the exam, submits answers as a JSON file to IPFS, and the CID is stored in SubmissionContract.sol.
3. Teacher fetches student’s IPFS-stored answers, evaluates, uploads the evaluated sheet to IPFS, and stores the result CID in EvaluationContract.sol.
4. Student fetches their results from the blockchain using the CID from EvaluationContract.sol.

## How to Run the Project?
1. Clone the repository: `git clone https://github.com/your-repo.git`
2. Install dependencies (React, Ethers.js, Go backend)
3. Deploy smart contracts to Sepolia testnet.
4. Run the frontend: `npm start`
5. Test transactions with MetaMask.

## Final Goal for the Hackathon
- Fully functional blockchain-based exam system
- Secure, decentralized exam storage and results
- Live demo using MetaMask and Sepolia testnet

Let’s divide tasks and build an awesome project.

