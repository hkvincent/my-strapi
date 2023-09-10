# Use the official Strapi image as the base image
FROM strapi/strapi

# Set environment variables for database connection
ENV DATABASE_CLIENT=mysql
ENV DATABASE_HOST=mysql
ENV DATABASE_PORT=3306
ENV DATABASE_NAME=strapi
ENV DATABASE_USERNAME=strapi
ENV DATABASE_PASSWORD=strapi
ENV DATABASE_SSL=false

# Expose the port Strapi will run on
EXPOSE 1337

# The command to run Strapi
CMD ["npm", "start"]
