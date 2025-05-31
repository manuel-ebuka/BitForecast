# 📈 BitForecast: Decentralized Bitcoin Price Prediction Markets

**BitForecast** is a transparent, decentralized, and permissionless protocol for Bitcoin price prediction markets built on the **Stacks blockchain**. Users can stake STX to take long or short positions on BTC/USD price movements, with rewards distributed proportionally based on market outcomes.

---

## 🏗️ Architecture Overview

```text
                        +---------------------+
                        |  Contract Owner     |
                        | (Admin Multisig)    |
                        +----------+----------+
                                   |
                      +------------v------------+
                      | BitForecast Clarity     |
                      | Smart Contract on Stacks|
                      +------------+------------+
                                   |
             +---------------------+----------------------+
             |                                            |
     +-------v--------+                         +--------v--------+
     | Oracle Provider|                         |     STX Users   |
     |  (End Price)   |                         | (Predictors /   |
     +-------+--------+                         |  Claimers)      |
             |                                  +--------+--------+
     +-------v--------+                                 |
     |  resolve-market|                                 |
     +----------------+                                 |
                                                        |
            +---------------------------+---------------+----------------+
            |                           |                                |
    +-------v--------+         +--------v--------+              +--------v--------+
    | create-market  |         | make-prediction |              |  claim-winnings |
    +----------------+         +-----------------+              +-----------------+
```

---

## 🔑 Features

* **Permissionless Market Creation:** Admin can create new BTC price prediction markets with specific block windows.
* **Stake-Based Predictions:** Users can stake STX on “up” or “down” BTC price movements.
* **Trustless Oracle Integration:** Market resolution via a verified oracle address.
* **Transparent Payouts:** Winnings distributed proportionally, minus a protocol fee.
* **Configurable Parameters:** Admin can update oracle, fee percentage, and minimum stake.

---

## 🧠 Core Concepts

* **Market:** A prediction event defined by a start block, end block, and BTC price window.
* **Prediction:** A user’s position (`"up"` or `"down"`) and the amount of STX staked.
* **Resolution:** Settled when the oracle provides an end price after market close.
* **Reward Distribution:** Winnings are calculated based on stake proportions and a fee is deducted.

---

## ⚙️ Smart Contract Functions

### 🔐 Admin Functions

| Function             | Description                                  |
| -------------------- | -------------------------------------------- |
| `create-market`      | Create a new prediction market.              |
| `resolve-market`     | Resolve a market using oracle BTC end price. |
| `set-oracle-address` | Update the oracle principal.                 |
| `set-minimum-stake`  | Change the minimum required STX stake.       |
| `set-fee-percentage` | Adjust the protocol fee percentage.          |
| `withdraw-fees`      | Withdraw accumulated protocol fees.          |

### 👤 User Functions

| Function          | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `make-prediction` | Participate in an active market with a BTC prediction. |
| `claim-winnings`  | Claim rewards from a resolved market.                  |

### 🔍 Read-Only Queries

| Function               | Description                              |
| ---------------------- | ---------------------------------------- |
| `get-market`           | Retrieve market details by ID.           |
| `get-user-prediction`  | View user position on a specific market. |
| `get-contract-balance` | Check current contract STX holdings.     |

---

## 💰 Payout Calculation

If your prediction wins:

```
Winnings = (Your Stake / Total Winning Stake) * Total Pool
Fee = (Winnings * fee-percentage) / 100
Payout = Winnings - Fee
```

---

## 📦 Deployment Checklist

* [ ] Deploy to Stacks mainnet/testnet using [Clarity tools](https://docs.stacks.co/write-smart-contracts/overview).
* [ ] Configure the oracle address post-deployment.
* [ ] Register admin multisig as `contract-owner`.

---

## 🛡️ Security Notes

* Only the **contract owner** can create or resolve markets.
* Oracle access is **restricted** to a pre-set address.
* Contract ensures **claim prevention** for ineligible predictions.
* Internal `asserts!` and `unwrap!` prevent invalid states.

---

## 🧪 Example Workflow

1. **Admin** creates a market from block `1000` to `1050`, starting at price `3000000000` sats.
2. **Users** submit `"up"` or `"down"` predictions with ≥ 1 STX.
3. After block `1050`, the **oracle** resolves the market with the end price.
4. **Winning users** claim rewards; protocol collects a fee.
