⎕io ← 0
count ← { +/ 'ACGT' ∘.= (,⍵) }    ⍝ replace 0 with your one-line implementation
count_t ← (+/ 'ACGT' ∘.= (,) )  ⍝ replace ⊢ with your one-line implementation
gc ← { 100 × (+/ ⍵ ∊ 'GC') ÷ ≢ ⍵ }       ⍝ replace 0 with your one-line implementation
gc_t ← (100 × (+/ ∊∘'GC') ÷ ≢ )    ⍝ replace ⊢ with your one-line implementation
magic ← { 1 = ≢ ∪ (+/ ⍵),⍥, (+⌿ ⍵),⍥, (+/ 0 0 ⍉ ⍵),⍥, +/ 0 0 ⍉ ⌽ ⍵ }    ⍝ replace 0 with your one-line implementation
magic_t ← (1 = (≢ ∘ ∪ ( (+/) ,⍥, (+⌿) ,⍥, (+/ 0 0 ⍉ ⊢) ,⍥, (+/ 0 0 ⍉ ⌽) )))  ⍝ replace ⊢ with your one-line implementation
