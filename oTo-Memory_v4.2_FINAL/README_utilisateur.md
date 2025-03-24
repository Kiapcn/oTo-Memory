# Guide utilisateur oTo-Memory

## Emplacement des données

Vos données sont stockées de manière sécurisée dans :
```
~/Library/Application Support/oTo-Memory/
```

### Structure des dossiers

- `user_memory/` : Contient vos conversations et votre mémoire
  - `last_topic.txt` : Dernier sujet discuté
  - `session_*.jsonl` : Historique des conversations par date
  - `backups/` : Sauvegardes automatiques

- `logs/` : Fichiers de diagnostic
  - `backend.log` : Logs du serveur backend
  - `flutter.log` : Logs de l'interface
  - `startup.log` : Historique des lancements

## Gestion des données

### Sauvegarde automatique
- Vos conversations sont sauvegardées quotidiennement
- Une sauvegarde est créée avant chaque mise à jour
- Les 5 dernières sauvegardes sont conservées

### Reprise des conversations
- À chaque lancement, oTo-Memory vous propose de continuer votre dernière conversation
- Vous pouvez accéder à l'historique complet dans le dossier `user_memory/`

### Diagnostic
En cas de problème :
1. Consultez les logs dans le dossier `logs/`
2. Vérifiez la dernière sauvegarde dans `user_memory/backups/`
3. Contactez le support si nécessaire

## Mise à jour

Pour mettre à jour l'application :
1. Utilisez le script `update_oTo.sh` fourni
2. Vos données seront automatiquement sauvegardées
3. La nouvelle version sera installée dans Applications

## Sécurité

- Vos données sont stockées localement sur votre machine
- Aucune donnée n'est envoyée sur Internet
- Les sauvegardes sont chiffrées

## Support

Pour toute question ou problème :
1. Consultez la documentation officielle
2. Vérifiez les logs dans le dossier `logs/`
3. Contactez le support via GitHub 