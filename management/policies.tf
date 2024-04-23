resource "spacelift_policy" "ignore-outside-project-root" {
  name = "Ignore pushes outside of project root - ${random_string.stack_name_suffix.result}"
  body = file("${path.module}/policies/ignore-outside-project-root.rego")
  type = "GIT_PUSH"

  labels   = toset(var.spacelift_labels)
  space_id = var.space_id
}

resource "spacelift_policy" "trigger-dependent-stacks" {
  name = "Trigger dependent stacks - ${random_string.stack_name_suffix.result}"
  body = file("${path.module}/policies/trigger-dependent-stacks.rego")
  type = "TRIGGER"

  labels   = toset(var.spacelift_labels)
  space_id = var.space_id
}

resource "spacelift_policy" "warn-on-unreachable-hosts" {
  name = "Require manual confirm on unreachable hosts - ${random_string.stack_name_suffix.result}"
  body = file("${path.module}/policies/warn-on-unreachable-hosts.rego")
  type = "PLAN"

  labels   = toset(var.spacelift_labels)
  space_id = var.space_id
}
