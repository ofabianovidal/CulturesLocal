# CulturesLocal

## Divisao de tarefas e videos

| Nome do Aluno | Telas sob sua responsabilidade | Link do Video de Defesa |
| --- | --- | --- |
| Fabiano Vidal | Tela de Login, Cadastro, Nova Senha, Index, Favoritos, Perfil, Meus Eventos | Adicionar link |
| Kleberson Costa | Notificacoes, Carrinho, Finalizar Compra, Suporte, Criar Evento, Filtros, Evento | Adicionar link |

## Entrega tecnica da atividade

- Firebase Authentication com login por e-mail/senha.
- Firebase Authentication com Google Sign-In.
- Bloqueio de acesso para e-mails fora do dominio `@souunit.com.br`.
- Cloud Firestore com CRUD em tempo real de eventos.
- Registros persistidos com o campo `criado_por`.
- Perfil do usuario carregado dinamicamente a partir do Firebase.

## Configuracao final do Firebase

1. Criar ou abrir o projeto do grupo no Firebase Console.
2. Ativar `Authentication` com os provedores `Email/Password` e `Google`.
3. Ativar `Cloud Firestore`.
4. Na pasta `culturelocal/`, rodar `flutterfire configure`.
5. Substituir `culturelocal/lib/firebase_options.dart` pelo arquivo gerado pela CLI.
6. Adicionar `google-services.json` em `culturelocal/android/app/`.
7. Adicionar `GoogleService-Info.plist` ao projeto iOS/macOS.
8. Cadastrar a SHA-1 usada no Android para o Google Sign-In funcionar.
9. Publicar as regras do arquivo `culturelocal/firestore.rules`.

## Checklist antes do prazo

- Confirmar que todos os commits foram feitos com a conta GitHub institucional.
- Atualizar os links dos videos individuais na tabela acima.
- Testar login com e-mail `@souunit.com.br`.
- Testar bloqueio de login para e-mails fora do dominio.
- Demonstrar criacao, leitura, atualizacao e exclusao no app e no Firebase Console ao mesmo tempo.
