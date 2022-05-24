package com.github.demo.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.datadoghq.datadog_lambda_java.DDLambda;
import com.github.demo.aws.model.StepFunctionObj;
import com.github.demo.aws.model.StepResult;

import org.apache.log4j.Logger;
import org.apache.log4j.MDC;

import datadog.trace.api.CorrelationIdentifier;

public class ProcessLambda implements RequestHandler<StepFunctionObj, StepFunctionObj> {

	private static final Logger LOG = Logger.getLogger(ProcessLambda.class);

    public StepFunctionObj handleRequest(StepFunctionObj input, Context context) {

        DDLambda  ddl  = new DDLambda(context);
      
        MDC.put("dd.trace_id", CorrelationIdentifier.getTraceId());
        MDC.put("dd.span_id", CorrelationIdentifier.getSpanId());
        LOG.info("Invoke ProcessLambda");
        LOG.debug("ProcessLambda :" + input);

        StepResult result = new StepResult();
        result.setCode("200");
        result.setMessage("Process completed successfully.");
        input.setProcess(result);
        ddl.finish();

        return input;

    }
}
