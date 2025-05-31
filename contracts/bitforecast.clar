;; BitForecast: Decentralized Bitcoin Price Prediction Markets
;;
;; A transparent and permissionless platform for Bitcoin price predictions
;; built on Stacks, enabling users to take positions on BTC price movements
;; and earn rewards based on market outcomes.

;; Constants

;; Administrative Constants
(define-constant contract-owner tx-sender) ;; Admin multisig address
(define-constant err-owner-only (err u100)) ;; Authorization error

;; Error Codes
(define-constant err-not-found (err u101)) ;; Data lookup error
(define-constant err-invalid-prediction (err u102)) ;; Invalid market position
(define-constant err-market-closed (err u103)) ;; Market lifecycle error
(define-constant err-already-claimed (err u104)) ;; Reward claim error
(define-constant err-insufficient-balance (err u105)) ;; STX balance check
(define-constant err-invalid-parameter (err u106)) ;; Input validation
(define-constant err-market-not-started (err u107)) ;; Early participation attempt
(define-constant err-market-ended (err u108)) ;; Late participation attempt
(define-constant err-market-already-resolved (err u109)) ;; Duplicate resolution

;; Protocol Parameters

;; Oracle address for price feed verification
(define-data-var oracle-address principal 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Economic parameters
(define-data-var minimum-stake uint u1000000) ;; 1 STX minimum position
(define-data-var fee-percentage uint u2) ;; 2% protocol fee (bps)

;; Market ID counter for sequential market creation
(define-data-var market-counter uint u0)

;; Data Structures

;; Market specification - stores all details about each prediction market
(define-map markets
  uint ;; market-id
  {
    start-price: uint, ;; BTC/USD opening price (sats)
    end-price: uint, ;; BTC/USD closing price (sats)
    total-up-stake: uint, ;; Aggregate long positions
    total-down-stake: uint, ;; Aggregate short positions
    start-block: uint, ;; Stacks block height - market open
    end-block: uint, ;; Stacks block height - market close
    resolved: bool, ;; Settlement status
  }
)