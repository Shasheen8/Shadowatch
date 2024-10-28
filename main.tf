locals {
  # Map remote state to locals
  aws_apex_account_id = data.terraform_remote_state.apex_global_state.outputs.TURO_BASTION_AWS_ACCOUNT_NUMBER
  aws_subaccount_id   = 663118211814
  aws_subaccount_name = lookup(data.terraform_remote_state.apex_global_state.outputs.SUB_ACCOUNTS_BY_ID, local.aws_subaccount_id)
  root_domain_zone_id = data.aws_route53_zone.rr_mu_apex_route_53_zone.zone_id
  root_domain         = "rr.mu"
  # Default values to use unless overridden for tests
  apex_team_names = data.terraform_remote_state.apex_global_state.outputs.TEAM_NAME_LIST
  team_names      = var.team_names != null ? var.team_names : local.apex_team_names

  # Map variables to locals
  environment                          = var.environment
  resources_unique_id                  = var.resources_unique_id
  resources_suffix                     = local.resources_unique_id == "" ? "" : format("-%s", local.resources_unique_id)
  networking_availability_zones_number = var.networking_availability_zones_number
  networking_vpc_cidr                  = var.networking_vpc_cidr
}

# Setup the subaccount
module "turo_subaccount" {
  source  = "app.terraform.io/turo/subaccount/aws"
  version = "12.0.0"

  aws_apex_account_id = local.aws_apex_account_id
  aws_subaccount_id   = local.aws_subaccount_id
  aws_subaccount_name = local.aws_subaccount_name
  root_domain_zone_id = local.root_domain_zone_id
  root_domain         = local.root_domain

  environment                          = local.environment
  networking_availability_zones_number = local.networking_availability_zones_number
  networking_vpc_cidr                  = local.networking_vpc_cidr
  resources_unique_id                  = local.resources_unique_id
  newrelic_account_id                  = "2841992"
  team_names                           = local.team_names
  limited_admin_teams                  = []

  pagerduty_event_orchestrations = {
    "engineering" = var.pagerduty_engineering_event_orchestration_integration_key_v1
  }
}

# We want the subaccount domain to be in rr.mu. We need its zone id to create the account domain
data "aws_route53_zone" "rr_mu_apex_route_53_zone" {
  provider = aws.apex
  name     = local.root_domain
}

data "aws_iam_policy" "ebs_csi_driver_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
