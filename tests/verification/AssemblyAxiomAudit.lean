/-
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
-/

-- Print production proof dependencies for review; this is not an automated allowlist check.
import VersoBlueprint.NodeAssembly.Laws
import VersoBlueprint.ExternalRef.Laws

#print axioms Informal.Contributions.collectorLaws
#print axioms Informal.Contributions.resolverLaws
#print axioms Informal.Contributions.resolve_collect
#print axioms Informal.Contributions.independentAssociations
#print axioms Informal.NodeAssembly.assemble_ok_resolve
#print axioms Informal.NodeAssembly.assemble_success_iff
#print axioms Informal.NodeAssembly.assemble_ok_priority
#print axioms Informal.NodeAssembly.assemble_ok_priority_none_iff
#print axioms Informal.NodeAssembly.assemble_ok_priority_some_iff
#print axioms Informal.NodeAssembly.assemble_ok_supports
#print axioms Informal.NodeAssembly.assemble_ok_blueprintAttributeAttachments
#print axioms Informal.NodeAssembly.assemble_ok_blueprintAttributeAttachments_iff
#print axioms Informal.NodeAssembly.assemble_ok_externalRefs
#print axioms Informal.NodeAssembly.assemble_ok_proofExternalRefs

#print axioms Informal.Data.ExternalRef.mergeSnapshots_canonical_union
#print axioms Informal.Data.ExternalRef.mergeSnapshots_normalized
#print axioms Informal.Data.ExternalRef.mergeSnapshots_canonical_nodup
#print axioms Informal.Data.ExternalRef.mergeSnapshots_present_iff
#print axioms Informal.Data.ExternalRef.mergeSnapshots_ref_present_iff
#print axioms Informal.Data.ExternalRef.mergeSnapshots_normalized_fixed
