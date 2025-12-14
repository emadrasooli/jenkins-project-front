FROM node:24-alpine AS builder

WORKDIR /app

ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000

RUN corepack enable && corepack prepare yarn --activate

COPY src ./src
COPY public ./public
COPY package.json yarn.lock .yarnrc.yml next.config.ts tsconfig.json postcss.config.mjs ./

RUN yarn install --immutable && yarn cache clean

RUN yarn build

FROM node:24-alpine AS runner

ENV NEXT_TELEMETRY_DISABLED=1

RUN corepack enable && corepack prepare yarn --activate

WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next

RUN yarn workspaces focus --production

EXPOSE 3000

CMD ["yarn", "start"]
