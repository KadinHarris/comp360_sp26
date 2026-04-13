#lang brag
smpl-program : [smpl-line] (/NEWLINE [smpl-line])*
@smpl-line : smpl-assign | smpl-print
smpl-assign : ID /"=" smpl-expr
smpl-print : /"print" [smpl-printable] (/";" [smpl-printable])*
@smpl-printable : STRING | smpl-expr
@smpl-expr : smpl-sum
smpl-sum : smpl-product (ADDOP smpl-product)*
smpl-product : smpl-atom (MULOP smpl-atom)*
@smpl-atom : INTEGER | DECIMAL | smpl-id | /"(" smpl-expr /")"
smpl-id : ID
