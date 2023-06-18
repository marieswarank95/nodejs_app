FROM public.ecr.aws/docker/library/node:12
WORKDIR app
COPY app.js .
RUN npm install express
CMD ["node", "app.js"]