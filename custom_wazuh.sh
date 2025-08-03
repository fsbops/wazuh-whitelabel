#!/bin/bash

set -e

echo "==> Script de customizacao do Wazuh Dashboard"

######################################
# VARIAVEIS COM LINKS DAS IMAGENS
######################################

# Favicon (PNG 16x16 e 32x32, ICO recomendado 48x48)
FAVICON_ICO_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"
FAVICON_16_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"
FAVICON_32_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"

# Logo da barra superior (SVG recomendado: até 220x44)
TOP_BAR_LOGO_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"

# Logo da tela de login (SVG recomendado: até 300x70)
LOGIN_LOGO_URL="https://hackershive.io/wp-content/uploads/2024/10/Logo-350x100-Elementor-fund-trans.png"

# Logo da tela de login (SVG recomendado: até 300x70)
HEALTHCHECK_LOGO_URL="https://hackershive.io/wp-content/uploads/2024/10/Logo-350x100-Elementor-fund-trans.png"

# Imagem de fundo da tela de login (SVG ou PNG com boa resolução, proporção livre)
LOGIN_BG_URL="https://w.wallhaven.cc/full/5d/wallhaven-5d3em9.png"

# Logo de carregamento (PNG recomendado: até 220x44)
LOADING_LOGO_URL="https://cdn.ead.guru/31532/media/public/Logo_Principal_GKpuVnD.png"
LOADING_LOGO_DARK_URL="https://hackershive.io/wp-content/uploads/2024/10/Logo-350x100-Elementor-fund-trans.png"

# Mini logo da dashboard (PNG recomendado: 24x24)
MINI_LOGO_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"
MINI_LOGO_DARK_URL="https://hackershive.io/wp-content/uploads/2024/10/428627995_999286831586199_2915274998790093152_n.jpg"

# Nome da aba do navegador
APP_TITLE="HHive SIEM"

# Texto da tela de login (opcional)
LOGIN_TITLE="SIEM"
LOGIN_SUBTITLE="Si vis pacem, para bellum"

# Caminho do YAML de configuração
DASH_CONF="/etc/wazuh-dashboard/opensearch_dashboards.yml"

####################################################################################################################
# CRIACAO E PROPRIEDADE DE DIRETORIOS E ARQUIVOS QUE SAO GERADOS SOMENTE CASO O UPLOAD SEJA FEITO PELA INTERFACE
####################################################################################################################

mkdir -p /usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/
chown -R wazuh-dashboard:wazuh-dashboard /usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom
touch /usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.app.png
touch /usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.healthcheck.png
touch /usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.reports.png

mkdir -p /usr/share/wazuh-dashboard/src/assets/images/
chown -R wazuh-dashboard:wazuh-dashboard /usr/share/wazuh-dashboard/src/assets
touch /usr/share/wazuh-dashboard/src/assets/images/wazuh.svg

mkdir -p /usr/share/wazuh-dashboard/src/plugins/login/assets/
touch /usr/share/wazuh-dashboard/src/plugins/login/assets/login-brand.svg

######################################
# LISTA DE IMAGENS PARA SUBSTITUIR
######################################

declare -A IMAGENS=(
  ["/usr/share/wazuh-dashboard/src/assets/images/wazuh.svg"]="$TOP_BAR_LOGO_URL"
  ["/usr/share/wazuh-dashboard/src/plugins/login/assets/login-brand.svg"]="$LOGIN_LOGO_URL"
  ["/usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.app.png"]="$LOADING_LOGO_URL"
  ["/usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.healthcheck.png"]="$HEALTHCHECK_LOGO_URL"
  ["/usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/customization.logo.reports.png"]="$HEALTHCHECK_LOGO_URL"
  ["/usr/share/wazuh-dashboard/src/core/server/core_app/assets/wazuh_login_bg.svg"]="$LOGIN_BG_URL"
  ["/usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons/favicon-16x16.png"]="$FAVICON_16_URL"
  ["/usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons/favicon-32x32.png"]="$FAVICON_32_URL"
  ["/usr/share/wazuh-dashboard/src/core/server/core_app/assets/favicons/favicon.ico"]="$FAVICON_ICO_URL"
)

######################################
# FUNCAO DE RESTAURACAO
######################################

restore_backups() {
  echo "==> Restaurando arquivos de backup..."
  for caminho in "${!IMAGENS[@]}"; do
    if [[ -f "${caminho}.bkp" ]]; then
      echo " - Restaurando $caminho"
      mv -f "${caminho}.bkp" "$caminho"
      chown wazuh-dashboard:wazuh-dashboard "$caminho"
      chmod 644 "$caminho"
    else
      echo " - Nenhum backup encontrado para $caminho"
    fi
  done

  if [[ -f "${DASH_CONF}.bkp" ]]; then
    echo " - Restaurando $DASH_CONF"
    mv -f "${DASH_CONF}.bkp" "$DASH_CONF"
    chown wazuh-dashboard:wazuh-dashboard "$DASH_CONF"
    chmod 640 "$DASH_CONF"
  else
    echo " - Nenhum backup encontrado para $DASH_CONF"
  fi

  echo "==> Reiniciando servicos..."
  systemctl restart wazuh-manager
  systemctl restart wazuh-dashboard

  echo "✅ Restauracao concluida."
}

######################################
# MODO RESTAURACAO
######################################

if [[ "$1" == "--restore" ]]; then
  restore_backups
  exit 0
fi

######################################
# BACKUP + DOWNLOAD DAS IMAGENS
######################################

echo "==> Substituindo arquivos de imagem..."
for caminho in "${!IMAGENS[@]}"; do
  url="${IMAGENS[$caminho]}"
  if [[ -f "$caminho" ]]; then
    echo " - Backup de $caminho"
    cp "$caminho" "$caminho.bkp"
  fi
  echo " - Baixando $url → $caminho"
  wget -q "$url" -O "$caminho"
  chown wazuh-dashboard:wazuh-dashboard "$caminho"
  chmod 644 "$caminho"
done

######################################
# EDICAO DO YAML DE CONFIGURACAO
######################################

DASH_CONF="/etc/wazuh-dashboard/opensearch_dashboards.yml"

echo "==> Ajustando arquivo de configuração: $DASH_CONF"
[[ -f "$DASH_CONF" && ! -f "$DASH_CONF.bkp" ]] && cp "$DASH_CONF" "$DASH_CONF.bkp"

# Verificação opcional: detecta se alguma chave já está presente
for chave in "opensearchDashboards.branding" "opensearch_security.basicauth.login"; do
  if grep -q "$chave" "$DASH_CONF"; then
    echo "[!] Aviso: chave \"$chave\" já existe em $DASH_CONF. Pode haver duplicidade."
  fi
done

cat <<EOF >> "$DASH_CONF"

# ===== Customizacoes adicionadas via script =====

# Nome da aba
opensearchDashboards.branding.applicationTitle: '$APP_TITLE'

# Texto opcional da tela de login
opensearch_security.basicauth.login.title: '$LOGIN_TITLE'
opensearch_security.basicauth.login.subtitle: '$LOGIN_SUBTITLE'

# Logo da tela de login
opensearch_security.basicauth.login.brandimage: "$LOGIN_LOGO_URL"

# Logos de carregamento
opensearchDashboards.branding:
  loadingLogo:
    defaultUrl: "$LOADING_LOGO_URL"
    darkModeUrl: "$LOADING_LOGO_DARK_URL"
  mark:
    defaultUrl: "$MINI_LOGO_URL"
    darkModeUrl: "$MINI_LOGO_DARK_URL"
EOF

chown wazuh-dashboard:wazuh-dashboard "$DASH_CONF"
chmod 640 "$DASH_CONF"


######################################
# RESTART DOS SERVICOS
######################################

echo "==> Reiniciando servicos..."
systemctl restart wazuh-manager
systemctl restart wazuh-dashboard

echo "✅ Customizacao aplicada com sucesso!"
