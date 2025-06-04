;; League Operator Verification Contract
;; Manages verification and registration of fantasy sports operators

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_VERIFIED (err u102))
(define-constant ERR_INVALID_OPERATOR (err u103))

;; Data structures
(define-map verified-operators principal bool)
(define-map operator-details principal {
    name: (string-ascii 50),
    license-number: (string-ascii 20),
    verification-date: uint,
    status: (string-ascii 10)
})

;; Verification functions
(define-public (verify-operator (operator principal) (name (string-ascii 50)) (license (string-ascii 20)))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-none (map-get? verified-operators operator)) ERR_ALREADY_VERIFIED)
        (map-set verified-operators operator true)
        (map-set operator-details operator {
            name: name,
            license-number: license,
            verification-date: block-height,
            status: "active"
        })
        (ok true)
    )
)

(define-public (revoke-operator (operator principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-some (map-get? verified-operators operator)) ERR_NOT_VERIFIED)
        (map-set verified-operators operator false)
        (map-set operator-details operator
            (merge (unwrap-panic (map-get? operator-details operator)) {status: "revoked"})
        )
        (ok true)
    )
)

;; Read-only functions
(define-read-only (is-verified-operator (operator principal))
    (default-to false (map-get? verified-operators operator))
)

(define-read-only (get-operator-details (operator principal))
    (map-get? operator-details operator)
)
