package com.github.demo.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.datadoghq.datadog_lambda_java.DDLambda;
import com.github.demo.aws.model.StepFunctionObj;
import com.github.demo.aws.model.StepResult;
import com.jayway.jsonpath.JsonPath;

import org.apache.log4j.Logger;
import org.apache.log4j.MDC;

import datadog.trace.api.CorrelationIdentifier;

public class ValidateLambda implements RequestHandler<Object, StepFunctionObj> {

	private static final Logger LOG = Logger.getLogger(ValidateLambda.class);

    public StepFunctionObj handleRequest(Object input, Context context) {       
        
        DDLambda  ddl  = new DDLambda(context);
      
        MDC.put("dd.trace_id", CorrelationIdentifier.getTraceId());
        MDC.put("dd.span_id", CorrelationIdentifier.getSpanId());

        LOG.info("Invoke ValidateLambda");
        LOG.debug("ValidateLambda: " + input);

        String bucket = JsonPath.read(input, "$.event.Records[0].s3.bucket.name");
        String key = JsonPath.read(input, "$.event.Records[0].s3.object.key");

        LOG.info(bucket);
        LOG.debug("key: " + key);

        StepFunctionObj stepFunctionObj = new StepFunctionObj();

        if (bucket != null && key != null && bucket.length() > 0 && key.length() > 0) {
            stepFunctionObj.setBucket(bucket);
            stepFunctionObj.setKey(key);
        } else {
            throw new RuntimeException("Validation failed.");
        }

        StepResult r = new StepResult();
        r.setCode("200");
        r.setMessage("Validation completed successfully.");
        stepFunctionObj.setValidate(r);
        ddl.finish();

        return stepFunctionObj;

    }
}
