# candidate-technical-demo

## Inputs

| Name       | Type   | Default | Required | Info                              |
| ---------- | ------ | ------- | -------- | --------------------------------- |
| identifier | String | -       | Yes      | String used to tag/name resources |

## Outputs

| Name            | Type   | Description                     |
| --------------- | ------ | ------------------------------- |
| this_lambda_arn | String | ARN of deployed Lambda function |
| this_invoke_url | String | Full url of deployed API stage  |

## Usage

```
module "tech_demo" {
    source     = "git@github.com:bengallagher/candidate-technical-demo.git"
    identifier = "tech-demo"
}
```
