# Define global args
ARG INSTBASE=/var/task

FROM public.ecr.aws/lambda/python:3.8 

WORKDIR ${INSTBASE}/

COPY src/requirements.txt ${INSTBASE}/

RUN pip install -r requirements.txt apig-wsgi==2.5.1 boto3

ENV LD_LIBRARY_PATH="/usr/local/lib/"

COPY src/ ${INSTBASE}/

# Create lambda_venv_path.py
RUN INSTBASE=${INSTBASE} python -c \
    'import os; import sys; instbase = os.environ["INSTBASE"]; print("import sys; sys.path[:0] = %s" % [p for p in sys.path if p.startswith(instbase)])' \
    > ${INSTBASE}/lambda_venv_path.py

ENV PYTHONPATH "${PYTHONPATH}:/var/task" # IMPORTANT TO SET THIS

CMD ["lambda_function.lambda_handler"]