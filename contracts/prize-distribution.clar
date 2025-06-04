;; Prize Distribution Contract
;; Handles prize pool management and distribution

(define-constant ERR_INSUFFICIENT_FUNDS (err u400))
(define-constant ERR_INVALID_CONTEST (err u401))
(define-constant ERR_CONTEST_NOT_ENDED (err u402))
(define-constant ERR_ALREADY_DISTRIBUTED (err u403))

;; Data structures
(define-map contests uint {
    contest-id: uint,
    entry-fee: uint,
    prize-pool: uint,
    participants: uint,
    status: (string-ascii 10),
    end-block: uint,
    winner: (optional principal)
})

(define-map contest-entries uint {
    contest-id: uint,
    participant: principal,
    lineup-id: uint,
    entry-time: uint
})

(define-map prize-distributions uint {
    contest-id: uint,
    first-place: uint,
    second-place: uint,
    third-place: uint,
    distributed: bool
})

(define-data-var next-contest-id uint u1)
(define-data-var platform-fee-rate uint u5) ;; 5% platform fee

;; Contest management
(define-public (create-contest (entry-fee uint) (end-block uint))
    (let ((contest-id (var-get next-contest-id)))
        (map-set contests contest-id {
            contest-id: contest-id,
            entry-fee: entry-fee,
            prize-pool: u0,
            participants: u0,
            status: "open",
            end-block: end-block,
            winner: none
        })
        (var-set next-contest-id (+ contest-id u1))
        (ok contest-id)
    )
)

(define-public (enter-contest (contest-id uint) (lineup-id uint))
    (let ((contest (unwrap! (map-get? contests contest-id) ERR_INVALID_CONTEST)))
        (asserts! (is-eq (get status contest) "open") ERR_INVALID_CONTEST)
        (asserts! (>= (stx-get-balance tx-sender) (get entry-fee contest)) ERR_INSUFFICIENT_FUNDS)

        ;; Transfer entry fee
        (try! (stx-transfer? (get entry-fee contest) tx-sender (as-contract tx-sender)))

        ;; Update contest
        (map-set contests contest-id
            (merge contest {
                prize-pool: (+ (get prize-pool contest) (get entry-fee contest)),
                participants: (+ (get participants contest) u1)
            })
        )

        ;; Record entry
        (map-set contest-entries (+ (* contest-id u1000) (get participants contest)) {
            contest-id: contest-id,
            participant: tx-sender,
            lineup-id: lineup-id,
            entry-time: block-height
        })

        (ok true)
    )
)

(define-public (end-contest (contest-id uint) (winner principal))
    (let ((contest (unwrap! (map-get? contests contest-id) ERR_INVALID_CONTEST)))
        (asserts! (>= block-height (get end-block contest)) ERR_CONTEST_NOT_ENDED)
        (asserts! (is-eq (get status contest) "open") ERR_INVALID_CONTEST)

        (map-set contests contest-id
            (merge contest {
                status: "ended",
                winner: (some winner)
            })
        )

        ;; Calculate prize distribution
        (let ((total-pool (get prize-pool contest))
              (platform-fee (/ (* total-pool (var-get platform-fee-rate)) u100))
              (prize-pool (- total-pool platform-fee)))
            (map-set prize-distributions contest-id {
                contest-id: contest-id,
                first-place: (/ (* prize-pool u60) u100),  ;; 60%
                second-place: (/ (* prize-pool u25) u100), ;; 25%
                third-place: (/ (* prize-pool u15) u100),  ;; 15%
                distributed: false
            })
        )

        (ok true)
    )
)

(define-public (distribute-prizes (contest-id uint) (first principal) (second principal) (third principal))
    (let ((contest (unwrap! (map-get? contests contest-id) ERR_INVALID_CONTEST))
          (distribution (unwrap! (map-get? prize-distributions contest-id) ERR_INVALID_CONTEST)))

        (asserts! (is-eq (get status contest) "ended") ERR_CONTEST_NOT_ENDED)
        (asserts! (not (get distributed distribution)) ERR_ALREADY_DISTRIBUTED)

        ;; Distribute prizes
        (try! (as-contract (stx-transfer? (get first-place distribution) tx-sender first)))
        (try! (as-contract (stx-transfer? (get second-place distribution) tx-sender second)))
        (try! (as-contract (stx-transfer? (get third-place distribution) tx-sender third)))

        ;; Mark as distributed
        (map-set prize-distributions contest-id
            (merge distribution {distributed: true})
        )

        (ok true)
    )
)

;; Read-only functions
(define-read-only (get-contest (contest-id uint))
    (map-get? contests contest-id)
)

(define-read-only (get-prize-distribution (contest-id uint))
    (map-get? prize-distributions contest-id)
)
