################################################################
# Titre: AWS Network Firewall (Egress L7 Inspection)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "aws_networkfirewall_rule_group" "domain_whitelist" {
  capacity = 100
  name     = "rg-domain-whitelist-lab"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [
          ".github.com",
          ".githubusercontent.com",
          ".amazonaws.com",
          ".ravindra-job.com",
          ".ubuntu.com"
        ]
      }
    }
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
  }
}

resource "aws_networkfirewall_firewall_policy" "egress_policy" {
  name = "policy-nfw-egress-lab"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
    
    stateful_default_actions = ["aws:drop_strict"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.domain_whitelist.arn
      priority     = 10
    }
  }
}

resource "aws_networkfirewall_firewall" "lab_nfw" {
  name                = "nfw-egress-lab"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.egress_policy.arn
  vpc_id              = var.vpc_id
  subnet_mapping {
    subnet_id = var.firewall_subnet_id
  }
}
