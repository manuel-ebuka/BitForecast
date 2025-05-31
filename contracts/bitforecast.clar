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

;; User positions - tracks individual positions and claim status
(define-map user-predictions
  {
    market-id: uint,
    user: principal,
  }
  {
    prediction: (string-ascii 4), ;; "up" or "down"
    stake: uint, ;; STX committed
    claimed: bool, ;; Reward status
  }
)

;; Market Administration

;; Create a new Bitcoin price prediction market
(define-public (create-market
    (start-price uint)
    (start-block uint)
    (end-block uint)
  )
  (let ((market-id (var-get market-counter)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> end-block start-block) err-invalid-parameter)
    (asserts! (> start-price u0) err-invalid-parameter)
    (map-set markets market-id {
      start-price: start-price,
      end-price: u0,
      total-up-stake: u0,
      total-down-stake: u0,
      start-block: start-block,
      end-block: end-block,
      resolved: false,
    })
    (var-set market-counter (+ market-id u1))
    (ok market-id)
  )
)

;; Finalize market with oracle-provided price
(define-public (resolve-market
    (market-id uint)
    (end-price uint)
  )
  (let ((market (unwrap! (map-get? markets market-id) err-not-found)))
    (asserts! (is-eq tx-sender (var-get oracle-address)) err-owner-only)
    (asserts! (>= stacks-block-height (get end-block market)) err-market-ended)
    (asserts! (not (get resolved market)) err-market-already-resolved)
    (asserts! (> end-price u0) err-invalid-parameter)
    (map-set markets market-id
      (merge market {
        end-price: end-price,
        resolved: true,
      })
    )
    (ok true)
  )
)