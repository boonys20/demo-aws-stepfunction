package com.github.demo.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.github.demo.aws.model.StepFunctionObj;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import datadog.trace.api.CorrelationIdentifier;

public class ExceptionLambda implements RequestHandler<StepFunctionObj, StepFunctionObj> {

    private static final String EXCEPTION_LAMBDA = "ExceptionLambda";
    private Logger logger = LoggerFactory.getLogger(Class.class);

    public StepFunctionObj handleRequest(StepFunctionObj input, Context context) {
        MDC.put("dd.trace_id", CorrelationIdentifier.getTraceId());
        MDC.put("dd.span_id", CorrelationIdentifier.getSpanId());
        logger.info("Invoke ExceptionLambda");
        logger.debug(EXCEPTION_LAMBDA + input);
        return input;
    }
}
