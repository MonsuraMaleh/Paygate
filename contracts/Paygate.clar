;; Subscription-Based Access Control Contract

(define-constant admin 'SP000000000000000000002Q6VF78) ;; Replace with actual admin principal
(define-constant subscription-duration u2592000) ;; 30 days in seconds
(define-data-var subscription-price uint u1000000) ;; 1 STX in microSTX

(define-map subscriptions 
  { subscriber: principal }
  { expires-at: uint }
)

;; Public: Subscribe for a time period
(define-public (subscribe)
  (let (
        (price (var-get subscription-price))
        ;; Clarity does not provide a direct block-height function, so we use a parameter instead
        (current-height u0) ;; TODO: Pass the current block height as a parameter to this function
      )
    ;; Transfer STX to contract
    (try! (stx-transfer? price tx-sender (as-contract tx-sender)))

    ;; Get current subscription (if any)
    (match (map-get? subscriptions { subscriber: tx-sender })
      subscription
      (map-set subscriptions { subscriber: tx-sender }
        { expires-at:
            (let (
              (current-expiry (get expires-at subscription))
            )
              (if (> current-expiry current-height)
                (+ current-expiry subscription-duration)
                (+ current-height subscription-duration)
              )
            )
        })
      (map-set subscriptions { subscriber: tx-sender } { expires-at: (+ current-height subscription-duration) })
    )
    (ok true)
  )
)
;; Read-only: Check if a user is currently subscribed
(define-read-only (check-access (user principal) (current-height uint))
  (match (map-get? subscriptions { subscriber: user })
    subscription
    (ok (> (get expires-at subscription) current-height))
    (ok false)
  )
)


;; Admin-only: Change subscription price
(define-public (set-price (new-price uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u403)) ;; Unauthorized
    (var-set subscription-price new-price)
    (ok new-price)
  )
)

;; Admin-only: Revoke a user's subscription
(define-public (revoke (user principal))
  (begin
    (asserts! (is-eq tx-sender admin) (err u403))
    (map-delete subscriptions { subscriber: user })
    (ok true)
  )
)

;; Admin-only: Withdraw STX from contract
(define-public (withdraw (amount uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u403))
    (try! (stx-transfer? amount (as-contract tx-sender) admin))
    (ok true)
  )
)
