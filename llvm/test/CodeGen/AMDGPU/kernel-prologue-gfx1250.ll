; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 < %s | FileCheck %s --check-prefix=INITIAL-VMEM
; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 -mattr=-wait-xcnt < %s | FileCheck %s --check-prefix=INITIAL-VMEM
; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 -mattr=-requires-initial-unclause-vmem < %s | FileCheck %s --check-prefix=WAIT-XCNT
; RUN: llc -mtriple=amdgcn -mcpu=gfx1250 -mattr=-wait-xcnt,-requires-initial-unclause-vmem < %s | FileCheck %s --check-prefix=NEITHER

define amdgpu_kernel void @kernel() {
; INITIAL-VMEM-LABEL: kernel:
; INITIAL-VMEM:       ; %bb.0:
; INITIAL-VMEM-NEXT:    s_mov_b64 s[64:65], 0
; INITIAL-VMEM-NEXT:    v_nop
; INITIAL-VMEM-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
; INITIAL-VMEM-NEXT:    global_prefetch_b8 v0, s[64:65] scope:SCOPE_SE
; INITIAL-VMEM-NEXT:    s_endpgm
;
; WAIT-XCNT-LABEL: kernel:
; WAIT-XCNT:       ; %bb.0:
; WAIT-XCNT-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 25, 1), 1
; WAIT-XCNT-NEXT:    s_endpgm
;
; NEITHER-LABEL: kernel:
; NEITHER:       ; %bb.0:
; NEITHER-NEXT:    s_endpgm
  ret void
}
