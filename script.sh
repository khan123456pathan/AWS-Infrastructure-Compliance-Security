#!/bin/bash
echo "Getting Security Hub Findings Locally"

aws securityhub get-findings --region ap-south-1 --filters '{"SeverityLabel": [{"Value": "CRITICAL", "Comparison": "EQUALS"}, {"Value": "CRITICAL", "Comparison": "EQUALS"}]}' >> securityhub.json

ls

if [ $? -eq 0 ]
then
	echo -e "\nFindings gathered successfully from AWS Security Hub"
else
	echo -e "\nError: Failed to get AWS Securit Hub Findings"
	exit 123
fi


curl -X 'POST' \
  'http://43.204.237.248:8080/api/v2/import-scan/' \
  -H 'accept: application/json' \
  -H 'Authorization: Basic YWRtaW46Uk0xalhwdmFoVDVsVzJmb1dnaEptdw==' \
  -H 'Content-Type: multipart/form-data' \
  -H 'X-CSRFTOKEN: nImiciWUBey0h4Z7dnrDSE0CZhK5TkdL4LDTKKpubmtHmXArwezr7qROzMiOo0S4' \
  -F 'product_type_name=' \
  -F 'active=true' \
  -F 'endpoint_to_add=' \
  -F 'verified=true' \
  -F 'close_old_findings=false' \
  -F 'test_title=' \
  -F 'engagement_name=' \
  -F 'build_id=' \
  -F 'deduplication_on_engagement=' \
  -F 'push_to_jira=false' \
  -F 'minimum_severity=Info' \
  -F 'close_old_findings_product_scope=false' \
  -F 'scan_date=2023-08-28' \
  -F 'create_finding_groups_for_all_findings=true' \
  -F 'engagement_end_date=' \
  -F 'environment=' \
  -F 'service=' \
  -F 'commit_hash=' \
  -F 'group_by=' \
  -F 'version=' \
  -F 'api_scan_configuration=' \
  -F 'product_name=awssecurity-rnd' \
  -F 'file=@securityhub.json;type=application/json' \
  -F 'auto_create_context=' \
  -F 'lead=' \
  -F 'scan_type=AWS Security Hub Scan' \
  -F 'branch_tag=' \
  -F 'source_code_management_uri=' \
  -F 'engagement=3'

if [ $? -eq 0 ]
then
	echo -e "\nReport Sent Successfully"
else 
	echo -e "\nFailed to Sent Report"
fi
