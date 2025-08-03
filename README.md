# 🛠️ Wazuh Whitelabel Script

Este projeto fornece um script bash automatizado (`custom_wazuh.sh`) para personalizar a interface visual do Wazuh Dashboard. Ele permite alterar logos, títulos, plano de fundo e outros elementos gráficos da interface de forma rápida e reversível.

---

## 📦 Funcionalidades

- Substituição automática de imagens (logos, favicons, plano de fundo, etc.)
- Alteração de textos da aba do navegador e da tela de login
- Criação de backups `.bkp` dos arquivos modificados
- Modo reverso: restaura os arquivos originais com segurança
- Reinicialização dos serviços `wazuh-manager` e `wazuh-dashboard`

---

## ⚙️ Requisitos

- Linux com privilégios de `root`.
- Wazuh 4.12 instalado (versão testada).
- Testes realizados em uma instalação limpa do Wazuh através de script fornecido no site da ferramenta.
- Testado em LXC Debian GNU/Linux versão 12. Apesar de não ser uma versão suportada originalmente pelo Wazuh, isto não altera os caminhos de instalação.
- Ferramentas básicas do sistema: `bash`, `wget`, `cp`, `touch`, `systemctl`, `chown`, `chmod`

---

## 🚀 Como usar

1. Clone este repositório:
   ```bash
   git clone https://github.com/fsbops/wazuh-whitelabel.git
   cd wazuh-whitelabel
   ```

2. Edite o script `custom_wazuh.sh` e substitua os links das imagens por URLs personalizadas (com tamanho e proporções adequadas conforme indicações nos comentários do script).

3. Execute o script como root:
   ```bash
   sudo bash +x custom_wazuh.sh
   ```

---

## 🔄 Modo reverso (restauração)

Caso queira desfazer as alterações realizadas:
```bash
sudo bash custom_wazuh.sh --restore
```

O script restaurará os arquivos modificados a partir dos backups `.bkp`.

---

## 🔍 Documentação relacionada

Para saber mais sobre as possibilidades de customização visual no Wazuh, veja a documentação oficial:

📘 [Wazuh Dashboard - Custom Branding](https://documentation.wazuh.com/current/user-manual/wazuh-dashboard/custom-branding.html)

---

## ⚠️ Aviso importante

> **Testado apenas na versão 4.12 do Wazuh (versão corrente em agosto/2025).**  
> Não me responsabilizo por quebras de execução, falhas de interface ou carregamento após o uso do script.  
> Imagens com tamanhos ou proporções inadequadas podem causar lentidão ou falha no carregamento, especialmente no primeiro acesso.  
> Algumas das funcionalidades utilizadas neste script já estão sinalizadas para depreciação em futuras versões do Wazuh.  
> **Recomenda-se utilizar este script primeiramente em ambientes de teste, para avaliação.**

---

## 🧠 Objetivos educacionais

O uso deste script e das imagens ilustrativas tem caráter **exclusivamente educacional e experimental** (um salve pro Daniel Donda, da [Hackers Hive](http://hackershive.io/), que eu sei que não vai embaçar haha), sem fins lucrativos. Ele visa demonstrar a viabilidade da personalização da interface do Wazuh Dashboard.

---

## 🧠 BUGs conhecidos

- A substituição da logo do healtcheck pode ou não funcionar. Durante os testes, algumas vezes funcionou e outras não. Pode ser necessário adicionar a imagem manualmente através da inteface web após a execução do script. Este é um dos tópicos que já estão reservados para análise futura (embora a alteração via script não seja recomendada pela equipe do Wazuh e esteja marcada para depreciação futura). 

---

## 🤝 Contribuições

Sugestões, correções ou melhorias são bem-vindas!  
Abra uma [issue](https://github.com/seu-usuario/wazuh-dashboard-custom/issues) ou envie um pull request.
