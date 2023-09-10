####################################################################################################
## Build Packages

FROM node:18-alpine AS builder

# Install necessary build tools and libraries
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1


# Set environment variable for production
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Set working directory and copy package files
WORKDIR /strapi
COPY . /strapi
COPY package.json ./
COPY yarn.lock ./

ENV PATH /opt/node_modules/.bin:$PATH

# RUN npm install husky
# RUN npm install --omit=dev --legacy-peer-deps
RUN yarn install


# Set PATH for node_modules binaries
ENV PATH /strapi/node_modules/.bin:$PATH

# Copy the rest of the application files
COPY . .

# Build the Strapi application
RUN npm run build

####################################################################################################
## Create Production Image

FROM node:18-alpine AS runtime

# Install necessary runtime libraries
RUN apk add --no-cache vips-dev && \
    rm -rf /var/cache/apk/*

# Set environment variable for production
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# MySQL Database connection environment variables


# Set working directory
WORKDIR /strapi

# Copy node_modules from builder stage
COPY --from=builder /strapi/node_modules ./node_modules

# Copy built Strapi application from builder stage
COPY --from=builder /strapi ./

# Set PATH for node_modules binaries
ENV PATH /strapi/node_modules/.bin:$PATH

# Set permissions for the Strapi directory
RUN chown -R node:node /strapi

# Switch to non-root user
USER node

# Expose Strapi port
EXPOSE 1337

# Command to run Strapi
CMD ["npm", "run", "start"]
