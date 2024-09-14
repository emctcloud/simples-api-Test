FROM node:18-alpine

# Define o diretório de trabalho dentro do contêiner
WORKDIR /usr/src/app

# Copia os arquivos package.json e package-lock.json
COPY src/index.js package*.json ./

# Instala as dependências
RUN npm install --production

# Copia o restante dos arquivos da aplicação para o diretório de trabalho
COPY ./src ./src

# Expõe a porta que a aplicação usará
EXPOSE 3000

# Define o comando para rodar a aplicação
CMD [ "npm", "start" ]
