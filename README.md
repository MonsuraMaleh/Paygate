PayGate-STX
A decentralized payment gateway built with Clarity on the Stacks blockchain.
It allows merchants and developers to accept STX payments securely with on-chain tracking.

Features
Create unique payment requests with order IDs
Pay securely in STX
Track payment status (pending, paid, settled)
Merchants can withdraw funds after confirmation
Transparent event logs for all transactions

Technical Overview
Language: Clarity
Core Functions:
create-payment – merchant creates a new payment request
pay – user pays for the request in STX
get-status – check payment status by order ID
withdraw – merchant withdraws settled payments

Installation & Usage
Clone repository:
git clone https://github.com/your-repo/paygate-stx.git
cd paygate-stx

Deploy with Clarinet:
clarinet contract deploy paygate-stx

Run tests:
clarinet test

Roadmap
Add SIP-010 token support (stablecoins, wrapped BTC)
Enable refunds for failed/expired payments
Add recurring subscription payments
Security audit & gas optimizations

License
MIT License – free to use, modify, and distribute.
