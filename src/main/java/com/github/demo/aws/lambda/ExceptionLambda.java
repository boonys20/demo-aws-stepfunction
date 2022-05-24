package com.github.demo.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.datadoghq.datadog_lambda_java.DDLambda;
import com.github.demo.aws.model.StepFunctionObj;

import org.apache.log4j.Logger;

public class ExceptionLambda implements RequestHandler<StepFunctionObj, StepFunctionObj> {

    private static final String EXCEPTION_LAMBDA = "ExceptionLambda";
	private static final Logger LOG = Logger.getLogger(ExceptionLambda.class);

    public StepFunctionObj handleRequest(StepFunctionObj input, Context context) {
        DDLambda  ddl  = new DDLambda(context);
        LOG.debug(EXCEPTION_LAMBDA + input);
        ddl.finish();
        return input;
    }
}
