# Verification lane: strengthen the production proof boundary

Owner: contribution/verification lane.
Status: V1 and V2a implemented; V2b is the next bounded milestone.
Foundation: [#467](https://github.com/leanprover/verso-blueprint/pull/467)
established the production identified-evidence resolver and its laws;
[#469](https://github.com/leanprover/verso-blueprint/pull/469) centralized admission
and separated node payloads from identified association and priority evidence.
V1 baseline: `fab2fc4470253bd854fca99c0530809357af5c54` on `v4.35.0`
(2026-10-23), including #469. V2a baseline:
`4943d3335ffa9221a39949e60836a8ad5dc2a456`, including
[#498](https://github.com/leanprover/verso-blueprint/pull/498).
V1 validation covers production/law builds, the full Lean/integration driver,
and the new/retained theorem axiom audit; local evidence remains untracked.

## Contract and working policy

Prove properties of production functions. Keep complete immutable evidence and
its accepted projections distinct. State every producer/coverage assumption;
do not add global API axioms to bypass an unproved adapter contract. Audit
theorem dependencies and keep proof imports outside production targets.

Each ticket records its baseline, scope, acceptance commands, proof assumptions,
and remaining boundary. Keep session allocation and approval notes in local
coordination records.

## Sequence and gates

| Ticket | Deliverable | Depends on | Scope |
| --- | --- | --- | --- |
| V1 (implemented) | Assembly acceptance, actual resolver-result bridge, input-facing priority laws | Landed #467 and #469 | `NodeAssembly/Laws.lean`; separate direct accepted-node return cleanup and regression |
| V2a (implemented) | Snapshot merge canonical union, normalization, uniqueness, and presence laws | V1 | Law module for `ExternalRef.mergeSnapshots` |
| V2b | Raw/present membership on each facet; `Node.leanDecls` union; payload frame | V2a | Assembly/data law modules |
| V3 | Semantic environment coherence and accepted index exactness | V2b; merged #469 admission boundary | Pure state transitions and their law modules; boundary regressions |
| V4 | Conservative completion through snapshot merge and `nodeCodeHealth` | V2a; agreed status/coverage contract | Status/health law modules; coordinate with axiom-analysis owner |
| V5 | Evidence persistence and rendering projection correspondence | Relevant V2/V3 results | One serializer/import or rendering boundary per ticket |
| V6 | Further indexed implementations refining the reference semantics | Measurements identifying a real bottleneck | One measured production query and its refinement theorem |

V3 and V4 are separate follow-ups; do not grow V1 into either. V5/V6 are queued
directions, not implementation-ready promises. Verification owns proofs of
Blueprint consumers. The axiom-analysis lane owns Lean observation APIs,
hidden-body/coverage experiments, upstream coordination, and dependency pins.

## V1: assembly acceptance and resolver-result bridge (implemented)

Behavior change: none. The admission cleanup returns the
accepted `Node` alongside `State` from `State.addNode`; `commitContribution`
consumes it directly instead of looking it up again. A direct registration
regression checks returned payloads, retained evidence, and the committed node.
The named theorems below live in
[`NodeAssembly/Laws.lean`](../../src/VersoBlueprint/NodeAssembly/Laws.lean)
and reuse [`resolverLaws`](../../src/VersoBlueprint/Contributions/Laws.lean).
No API preservation work, snapshot redesign, status policy, broader environment
refactor, or additional stored data.

1. `assemble_ok_resolve`: successful production assembly implies
   `resolve label records = .ok assembled.view`.
2. `assemble_success_iff` proves assembly success iff the actual payload reducer
   succeeds, relevant contribution identities do not collide, and priorities
   do not disagree. The theorem uses the complete record set. Authored-origin
   validity remains an environment obligation, not an invented assembler premise.
3. `assemble_ok_priority_none_iff` proves node priority `none` iff there is no
   input priority claim; `assemble_ok_priority_some_iff` proves node priority
   `some value` iff that value is claimed and all claims agree.
   Records without priority remain neutral.
4. Support and input-facing priority laws reuse the resolver bridge and
   `resolverLaws`; priority laws also reuse `assemble_ok_priority`. Existing
   theorem guarantees are preserved.

Acceptance commands (run from a harness-created worktree on the merged base):

```sh
python3 -m scripts.blueprint_harness require-branch-role default_dev
scripts/lean-low-priority lake build VersoBlueprint +VersoBlueprint.Contributions.Laws:olean +VersoBlueprint.NodeAssembly.Laws:olean
scripts/run-lean-tests.sh
scripts/lean-low-priority lake lean tests/verification/AssemblyAxiomAudit.lean
git diff --check
```

The tracked audit imports `VersoBlueprint.NodeAssembly.Laws` and prints axioms
of the new bridge, acceptance theorem, both priority corollaries, and retained
collector/resolver laws. It prints dependencies for review, rather than enforcing
an automated allowlist. Accept no `sorryAx`, new axioms, `sorry`, or `admit`.
Check production import closure remains independent of law modules. Existing CI
runs the broader tests; a proof-only change does not need new tests mirroring
the proof scripts. Any further production behavior change needs a separately
scoped fix with a counterexample; it is outside these laws.

Exit statement: production assembly succeeds exactly when its two reducers
permit it, and the returned node's priority agrees with the original identified
evidence. This does not yet prove actual node declaration membership, producer
correctness, environment coherence, or whole-database confluence.

## V2a: snapshot canonical union and presence (implemented)

Behavior change: none. The proof-only
[`ExternalRef/Laws.lean`](../../src/VersoBlueprint/ExternalRef/Laws.lean)
proves properties of the production `ExternalRef.mergeSnapshots` loop by showing
it equals the same indexed fold. Its local index-comparator laws and loop
invariants leave production imports unchanged and add no API axioms. Both `current` and
`incoming` are arbitrary arrays, including duplicates and missing references.

1. `mergeSnapshots_canonical_union`: output canonical fields are exactly the
   union of input canonical fields after one `eraseMacroScopes` application.
   This is raw membership, independent of presence.
2. `mergeSnapshots_normalized`: each output canonical field equals a one-pass
   erased input canonical field.
3. `mergeSnapshots_canonical_nodup`: output canonical fields have no duplicates.
4. `mergeSnapshots_present_iff`: a canonical name has a present output iff some
   input with that one-pass erased key is present.
   `mergeSnapshots_ref_present_iff` states the same fact for each output's
   actual `present` field.
5. `mergeSnapshots_normalized_fixed`: output canonical fields are erasure-fixed
   under the explicit premise that every input's one-pass erasure is stable.
   This premise is necessary: for arbitrary `Name` values, nested `_@` / `_hyg`
   suffixes can erase to a prefix that still has macro scopes. No repeated
   erasure or change to production canonicalization is part of this ticket.

Acceptance commands:

```sh
python3 -m scripts.blueprint_harness require-branch-role default_dev
scripts/lean-low-priority lake build VersoBlueprint +VersoBlueprint.Contributions.Laws:olean +VersoBlueprint.NodeAssembly.Laws:olean +VersoBlueprint.ExternalRef.Laws:olean
scripts/lean-low-priority lake lean tests/verification/AssemblyAxiomAudit.lean
git diff --check
```

CI builds the new law module explicitly and the tracked audit prints the six
new theorem dependencies alongside the existing assembly and contribution laws.
No facet, payload, environment, producer, status, or completion claim follows
from V2a alone. Missing references remain useful evidence in the raw union.

## V2b: facts reach the actual node

Next bounded milestone: lift the snapshot laws through facet folds and prove
actual accepted-node declaration membership and the payload frame. Keep
environment and completion policy work in their separate follow-ups.

Lift through each facet's support fold independently. Then prove, for the
actual accepted node, that `Node.leanDecls` contains exactly selected
associations union payload declarations. Retain the payload disjunct for
literate code and make canonical-name conventions explicit.

Add a frame property for payload bodies, dependencies, numbering, literate/Rust
code, markup, and unrelated metadata. Preserve explicit kind; allow the
documented association-based inference when kind is not explicit. Do not claim
literal equality of order-sensitive snapshot or support arrays under arbitrary
permutations.

## V3: coherent states and rejection

Scope the invariant to labels with retained contributions. Accepted nodes exist
exactly when authored-origin validity and assembly permit them, and equal that
accepted assembly. Index entries exist exactly for canonical declarations of
accepted nodes. Authored-origin conflicts prevent both nodes and index entries,
including after later local registration.

Prove initialization and preservation by supported registration and import
transitions. Rejection atomicity compares semantic stores; diagnostics and
`importedConflictsReported` may change legitimately. Use the merged #469
admission boundary, including the direct accepted-node return from
`State.addNode`; do not independently rewrite admission.

## V4: completion and evidence coverage

Lift `ProvedStatus.mergeConservative_isProved` through snapshots and actual
`nodeCodeHealth`, initially proving that an accepted non-proved observation
cannot become certified complete. Include both facets, literate overlap,
external-status overrides, and the nonempty-code requirement.

Stronger missing-status laws require the producer invariant
`present = false → provedStatus = .missing`. Retained supporting records and
aggregate status have different roles: absorbing statuses need not retain each
observation in the aggregate value. Any completion theorem over Lean observations
must expose soundness and coverage assumptions; cached absence is not coverage.

## Deferred persistence, rendering, and performance

For V5, choose one boundary and prove that semantic facts survive while resource
availability and occurrence presentation may vary. Include snapshot/document
pairing and serialization freshness when those are relevant; avoid promising
all generated-output correctness from a single projection theorem.

For V6, measure first, then prove refinement of the optimized production query
against the existing specification. Timing evidence and kernel proofs establish
different claims. No general database engine or persistent cache is authorized
by this plan.
