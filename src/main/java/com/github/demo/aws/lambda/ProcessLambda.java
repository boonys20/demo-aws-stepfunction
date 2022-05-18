package com.github.demo.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.github.demo.aws.model.StepFunctionObj;
import com.github.demo.aws.model.StepResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import datadog.trace.api.CorrelationIdentifier;

public class ProcessLambda implements RequestHandler<StepFunctionObj, StepFunctionObj> {

    private Logger logger = LoggerFactory.getLogger(Class.class);

    public StepFunctionObj handleRequest(StepFunctionObj input, Context context) {
       
        MDC.put("dd.trace_id", CorrelationIdentifier.getTraceId());
        MDC.put("dd.span_id", CorrelationIdentifier.getSpanId());
        logger.info("Invoke ProcessLambda");
        logger.debug("ProcessLambda :" + input);

        StepResult result = new StepResult();
        result.setCode("200");
        result.setMessage("Process completed successfully.");
        input.setProcess(result);

        return input;

    }
}
