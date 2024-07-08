## README: AWS-Powered Trading Algorithm

![image](https://github.com/sjvr33/trading-algos/assets/92934997/474d5ec3-31d7-4afb-a20c-1f9681611053)

Cool AWS-powered trading algorithm that uses financial broker API through MetaTrader5 on EC2 Server. The price information is process in batches every 15min and uses a combination of Lambda functions and EC2 scripts that is written in python to make trading decisions. Some of the code is stored in private repository as for some concepts I am still working on. Feel free to reach out for collaborations. 

### Tech Stack Overview

- **High-Performance EC2 Server**:
  - **Role**: Hosts MetaTrader 5, acting as the operational hub.
  - **Features**: Enhances trade execution speeds and secures connections to liquidity providers. Doubles as a bastion host for database security.
  - **Integration**: Features a seamless Python integration for dynamic trading adjustments.

- **Robust MySQL RDS Database**:
  - **Functionality**: Stores crucial market data and detailed trading strategies.
  - **Accessibility**: SQL Workbench integration for remote strategy modifications and data analysis.

### AWS Lambda Functions:

- **Data Importer**: Transfers real-time market data into our database.
- **Strategy Optimizer**: Processes data into actionable intelligence using advanced algorithms.
- **Trade Decider**: Evaluates and initiates trades based on analytical predictions.
- **Risk Manager**: Monitors and mitigates risks in open trades.

### Automation and Orchestration:

- **Paramiko Integration**: Empowers Lambda functions to execute remote Python scripts on EC2, enhancing automation capabilities.
- **AWS Step Functions and EventBridge**: Orchestrates the operational flow and scheduling of Lambda functions, ensuring precise and timely actions.

### Highlights and Innovations

- **Streamlined Operations**: Achieves near-zero human intervention in trade management.
- **Advanced Security Protocols**: Ensures top-tier protection for trading data and operations.
- **Rapid Response Mechanism**: Adapts swiftly to market changes, allowing for quick strategy adjustments.

### Note

I removed all private variables in scripts. 

Explore, fork, and contribute to our journey of transforming financial trading through advanced AWS technology
