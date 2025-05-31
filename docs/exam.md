Développer une application de chat avec liste des conversations et vue détaillée, utilisant Flutter et le pattern BLoC.

---

## LIVRABLES

1. Code source de l’application Flutter sur GitHub
2. Compte rendu de l’examen sous votre nom : `NomPrénom.pdf`, en expliquant :
   - Architecture BLoC utilisée avec ses états et ses évènements
   - Navigation entre les écrans
   - Fonctionnalités implémentées

---

## FONCTIONNALITÉS À IMPLÉMENTER

### 1. Écran Liste des conversations
- Liste des conversations avec avatar, nom, dernier message
- Badge pour les messages non lus
- Navigation vers l’écran de conversation détaillée
- Possibilité de créer une nouvelle conversation

### 2. Écran de la conversation détaillée
- Messages de la conversation sélectionnée
- Champ de saisie pour envoyer des messages
- Messages différenciés visuellement (utilisateur/contact)

---

## Modèles de Données

### ⇒ Conversation :
- `id` (String)
- `contactName` (String)
- `lastMessage` (String)
- `timestamp` (DateTime)

### ⇒ Message :
- `id` (String)
- `conversationId` (String)
- `content` (String)
- `isMe` (bool) *(pour aligner les bulles à droite/gauche)*
- `timestamp` (DateTime)

### ⇒ Gestion d’état avec BLoC
- `ConversationBloc` avec `state` immutable
- **Events** :
  - `LoadConversations`
  - `SendMessage`
  - `ReceiveMessage`

---

## Indications

- Simulez les données avec `mockConversations` et `mockMessages`
- Utilisez **Equatable** pour les états