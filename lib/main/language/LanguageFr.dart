import 'BaseLanguage.dart';

class LanguageFr extends BaseLanguage {
  @override
  String get appName => "Livraison puissante";
  @override
  String get language => "Langue";
  @override
  String get confirmation => "Confirmation";
  @override
  String get cancel => "Annuler";
  @override
  String get create => "Créer";
  @override
  String get filter => "Filtre";
  @override
  String get reset => "Réinitialiser";
  @override
  String get status => "Statut";
  @override
  String get date => "Date";
  @override
  String get from => "Depuis";
  @override
  String get to => "À";
  @override
  String get toDateValidationMsg => "À ce jour doit être après la date";
  @override
  String get applyFilter => "Appliquer le filtre";
  @override
  String get payment => "Paiement";
  @override
  String get paymentMethod => "méthodes de payement";
  @override
  String get payNow => "Payez maintenant";
  @override
  String get pleaseSelectCity => "Veuillez sélectionner la ville";
  @override
  String get selectRegion => "Choisissez une région";
  @override
  String get country => "Pays";
  @override
  String get city => "Ville";
  @override
  String get logoutConfirmationMsg => "Êtes-vous sûr de vouloir vous déconnecter ?";
  @override
  String get yes => "Oui";
  @override
  String get trackOrder => "Suivi de commande";
  @override
  String get deliveryNow => "Livrer maintenant";
  @override
  String get schedule => "Calendrier";
  @override
  String get pickTime => "Chronométrer";
  @override
  String get endTimeValidationMsg => "La fin du temps doit être après le début du temps";
  @override
  String get deliverTime => "Donner le temps";
  @override
  String get weight => "Poids";
  @override
  String get parcelType => "Type de colis";
  @override
  String get pickupInformation => "Informations de ramassage";
  @override
  String get address => "Adresse";
  @override
  String get contactNumber => "Numéro de contact";
  @override
  String get description => "Description";
  @override
  String get deliveryInformation => "Informations de livraison";
  @override
  String get packageInformation => "Informations sur les forfaits";
  @override
  String get deliveryCharge => "Frais de livraison";
  @override
  String get distanceCharge => "Charge de distance";
  @override
  String get weightCharge => "Charge de poids";
  @override
  String get extraCharges => "Frais supplémentaires";
  @override
  String get total => "Total";
  @override
  String get cash => "Espèces";
  @override
  String get online => "En ligne";
  @override
  String get paymentCollectFrom => "Paiement de paiement à partir de";
  @override
  String get saveDraftConfirmationMsg => "Êtes-vous sûr de vouloir enregistrer en tant que projet?";
  @override
  String get saveDraft => "Sauver le projet";
  @override
  String get createOrder => "Créer une commande";
  @override
  String get previous => "Précédent";
  @override
  String get pickupCurrentValidationMsg => "Le temps de ramassage doit être après l'heure actuelle";
  @override
  String get pickupDeliverValidationMsg => "Le temps de ramassage doit être avant de livrer l'heure";
  @override
  String get createOrderConfirmationMsg => "Êtes-vous sûr de passer la commande?";
  @override
  String get draftOrder => "Projet de commande";
  @override
  String get parcelDetails => "Détails de colis";
  @override
  String get aboutDeliveryMan => "À propos du livreur";
  @override
  String get aboutUser => "À propos de l'utilisateur";
  @override
  String get returnOrder => "Commande de retour";
  @override
  String get cancelOrder => "annuler la commande";
  @override
  String get lblReturn => "Retour";
  @override
  String get changePassword => "Changer le mot de passe";
  @override
  String get oldPassword => "ancien mot de passe";
  @override
  String get newPassword => "nouveau mot de passe";
  @override
  String get confirmPassword => "Confirmez le mot de passe";
  @override
  String get passwordNotMatch => "Le mot de passe ne correspond pas";
  @override
  String get saveChanges => "Sauvegarder les modifications";
  @override
  String get editProfile => "Editer le profil";
  @override
  String get notChangeEmail => "Vous ne pouvez pas modifier l'ID de messagerie";
  @override
  String get username => "Nom d'utilisateur";
  @override
  String get notChangeUsername => "Vous ne pouvez pas changer le nom d'utilisateur";
  @override
  String get forgotPassword => "Mot de passe oublié";
  @override
  String get email => "E-mail";
  @override
  String get submit => "Soumettre";
  @override
  String get userNotApproveMsg => "Votre profil est en cours d'examen. Attendez un peu de temps ou un contact avec votre administrateur.";
  @override
  String get password => "Mot de passe";
  @override
  String get forgotPasswordQue => "Mot de passe oublié ?";
  @override
  String get signIn => "Se connecter";
  @override
  String get doNotHaveAccount => "N'avez-vous pas de compte?";
  @override
  String get signUp => "S'inscrire";
  @override
  String get name => "Nom";
  @override
  String get alreadyHaveAnAccount => "Vous avez déjà un compte?";
  @override
  String get light => "Lumière";
  @override
  String get dark => "Sombre";
  @override
  String get systemDefault => "Défaillance du système";
  @override
  String get theme => "Thème";
  @override
  String get skip => "Sauter";
  @override
  String get getStarted => "Commencer";
  @override
  String get profile => "Profil";
  @override
  String get track => "Piste";
  @override
  String get active => "Actif";
  @override
  String get pickUp => "Ramasser";
  @override
  String get departed => "Défunt";
  @override
  String get imagePickToCamera => "Image photo à la caméra";
  @override
  String get imagePicToGallery => "Photo d'image à la galerie";
  @override
  String get orderDeliver => "Commande livrer";
  @override
  String get orderPickup => "Commande";
  @override
  String get info => "Info";
  @override
  String get paymentCollectFromDelivery => "Formulaire de percevoir de paiement à la livraison";
  @override
  String get paymentCollectFromPickup => "Formulaire de collecte de paiement sur le ramassage";
  @override
  String get pickupDatetime => "Date et heure de ramassage";
  @override
  String get deliveryDatetime => "Date et heure de livraison";
  @override
  String get save => "Sauvegarder";
  @override
  String get clear => "Clair";
  @override
  String get deliveryTimeSignature => "Signature de temps de livraison";
  @override
  String get reason => "Raison";
  @override
  String get selectDeliveryTimeMsg => "Veuillez sélectionner le délai de livraison";
  @override
  String get orderCancelledSuccessfully => "Commander annulé avec succès";
  @override
  String get trackingOrder => "Commande de suivi";
  @override
  String get assign => "Attribuer";
  @override
  String get pickedUp => "Ramassé";
  @override
  String get arrived => "Arrivé";
  @override
  String get completed => "Complété";
  @override
  String get cancelled => "Annulé";
  @override
  String get allowLocationPermission => "Autoriser l'autorisation de l'emplacement";
  @override
  String get walkThrough1Title => "Sélectionnez l'emplacement de ramassage";
  @override
  String get walkThrough2Title => "Sélectionnez l'emplacement de la chute";
  @override
  String get walkThrough3Title => "Confirmer et se détendre";
  @override
  String get walkThrough1Subtitle => "Cela nous aide à obtenir un forfait à votre porte.";
  @override
  String get walkThrough2Subtitle => "Afin que nous puissions livrer rapidement le colis à la bonne personne.";
  @override
  String get walkThrough3Subtitle => "Nous livrerons votre colis à temps et en parfait état.";
  @override
  String get order => "Commande";
  @override
  String get account => "Compte";
  @override
  String get drafts => "Brouillons";
  @override
  String get aboutUs => "À propos de nous";
  @override
  String get helpAndSupport => "Support d'aide";
  @override
  String get logout => "Se déconnecter";
  @override
  String get selectCity => "Sélectionnez une ville";
  @override
  String get next => "Suivant";
  @override
  String get fieldRequiredMsg => "Ce champ est obligatoire";
  @override
  String get emailInvalid => "Le courriel est invalide";
  @override
  String get passwordInvalid => "La longueur minimale du mot de passe devrait être de 6";
  @override
  String get usernameInvalid => "Le nom d'utilisateur ne doit pas contenir d'espace";
  @override
  String get writeReasonHere => "Écrivez la raison ici ...";
  @override
  String get areYouSureWantToArrive => "Êtes-vous sûr de vouloir arriver?";
  @override
  String get note => "Note:";
  @override
  String get courierWillPickupAt => "Courier va ramasser à";
  @override
  String get courierWillDeliverAt => "Courier livrera à";
  @override
  String get confirmDelivery => "Confirmer la livraison";
  @override
  String get orderPickupConfirmation => "Êtes-vous sûr de vouloir récupérer cette commande?";
  @override
  String get orderDepartedConfirmation => "Êtes-vous sûr de vouloir quitter cette commande?";
  @override
  String get orderCreateConfirmation => "Êtes-vous sûr de vouloir créer cette commande?";
  @override
  String get orderCompleteConfirmation => "Êtes-vous sûr de vouloir terminer cette commande?";
  @override
  String get orderCancelConfirmation => "Êtes-vous sûr de vouloir annuler cette commande?";
  @override
  String get rememberMe => "Souviens-toi de moi";
  @override
  String get becomeADeliveryBoy => "Devenir un livreur";
  @override
  String get orderHistory => "Historique des commandes";
  @override
  String get no => "Non";
  @override
  String get confirmPickup => "Confirmer le ramassage";
  @override
  String get contactUs => "Contactez-nous";
  @override
  String get purchase => "Achat";
  @override
  String get privacyPolicy => "politique de confidentialité";
  @override
  String get termAndCondition => "Termes et conditions";
  @override
  String get notifyUser => "Informer l'utilisateur";
  @override
  String get userSignature => "Signature de l'utilisateur";
  @override
  String get notifications => "Notifications";
  @override
  String get pickupLocation => "Lieu de ramassage";
  @override
  String get deliveryLocation => "Lieu de livraison";
  @override
  String get myOrders => "Mes commandes";
  @override
  String get paymentType => "Type de paiement";
  @override
  String get orderId => "Numéro de commande";
  @override
  String get viewHistory => "Voir l'historique";
  @override
  String get paymentDetails => "Détails de paiement";
  @override
  String get paymentStatus => "Statut de paiement";
  @override
  String get cancelledReason => "Raison annulée";
  @override
  String get returnReason => "Retour Raison";
  @override
  String get pleaseConfirmPayment => "Veuillez confirmer le paiement";
  @override
  String get picked => "Choisi";
  @override
  String get at => "À";
  @override
  String get delivered => "Livré";
  @override
  String get yourLocation => "Votre emplacement";
  @override
  String get lastUpdateAt => "Dernière mise à jour à";
  @override
  String get uploadFileConfirmationMsg => "Êtes-vous sûr de vouloir télécharger ce fichier?";
  @override
  String get verifyDocument => "Vérifier le document";
  @override
  String get selectDocument => "Sélectionner un document";
  @override
  String get addDocument => "Ajouter un document";
  @override
  String get deleteMessage => "Supprimer le message?";
  @override
  String get writeAMessage => "Écrire un message...";
  @override
  String get pending => "En attente";
  @override
  String get failed => "Échoué";
  @override
  String get paid => "Payé";
  @override
  String get onPickup => "Lors du ramassage";
  @override
  String get onDelivery => "À la livraison";
  @override
  String get stripe => "Bande";
  @override
  String get razorpay => "Razorpay";
  @override
  String get payStack => "Dos de paiement";
  @override
  String get flutterWave => "Ondulation";
  @override
  String get deliveryContactNumber => "Numéro de contact de livraison";
  @override
  String get deliveryDescription => "Description de livraison";
  @override
  String get success => "Succès";
  @override
  String get paypal => "Pay Pal";
  @override
  String get payTabs => "Mât de paie";
  @override
  String get mercadoPago => "Mercado Pago";
  @override
  String get paytm => "Paytm";
  @override
  String get myFatoorah => "Ma fatoorah";
  @override
  String get demoMsg => "Le rôle du testeur n'est pas autorisé à effectuer cette action";
  @override
  String get verificationCompleted => "Vérification terminée";
  @override
  String get codeSent => "Code envoyé";
  @override
  String get otpVerification => "Vérification OTP";
  @override
  String get enterTheCodeSendTo => "Entrez le code envoyé à";
  @override
  String get invalidVerificationCode => "Code de vérification invalide";
  @override
  String get didNotReceiveTheCode => "Ne recevait pas le code?";
  @override
  String get resend => "Revivre";
  @override
  String get numberOfParcels => "Nombre de colis";
  @override
  String get invoice => "Facture";
  @override
  String get customerName => "Nom du client:";
  @override
  String get deliveredTo => "Livré à:";
  @override
  String get invoiceNo => "N ° de facture:";
  @override
  String get invoiceDate => "Date de facture:";
  @override
  String get orderedDate => "Date commandée:";
  @override
  String get invoiceCapital => "FACTURE";
  @override
  String get product => "Produit";
  @override
  String get price => "Prix";
  @override
  String get subTotal => "Sous-total";
  @override
  String get phoneNumberInvalid => "Le numéro de téléphone fourni n'est pas valide.";
  @override
  String get placeOrderByMistake => "Passer la commande par erreur";
  @override
  String get deliveryTimeIsTooLong => "Le délai de livraison est trop long";
  @override
  String get duplicateOrder => "Commande en double";
  @override
  String get changeOfMind => "Changement d'esprit";
  @override
  String get changeOrder => "Change l'ordre";
  @override
  String get incorrectIncompleteAddress => "Adresse incorrecte / incomplète";
  @override
  String get other => "Autre";
  @override
  String get wrongContactInformation => "Mauvaises coordonnées";
  @override
  String get paymentIssue => "Problème de paiement";
  @override
  String get personNotAvailableOnLocation => "Personne non disponible sur place";
  @override
  String get invalidCourierPackage => "Package de messagerie non valide";
  @override
  String get courierPackageIsNotAsPerOrder => "Le package de messagerie n'est pas comme ordonnance";
  @override
  String get invalidOrder => "Commande non valide";
  @override
  String get damageCourier => "Dommage à la courrier";
  @override
  String get sentWrongCourier => "Envoyé un mauvais courrier";
  @override
  String get notAsOrder => "Pas comme l'ordre";
  @override
  String get pleaseSelectValidAddress => "Veuillez sélectionner l'adresse valide";
  @override
  String get selectedAddressValidation => "L'adresse sélectionnée doit durer au moins 3 lettres";
  @override
  String get orderArrived => "L'ordre est arrivé";

  @override
  String get deleteAccount => "Supprimer le compte";
  @override
  String get deleteAccountMsg1 => "Êtes-vous sûr de vouloir supprimer votre compte? Veuillez lire comment la suppression du compte affectera.";
  @override
  String get deleteAccountMsg2 =>
      "La suppression de votre compte supprime les informations personnelles de notre base de données. Votre e-mail est réservé en permanence et le même e-mail ne peut pas être réutilisé pour enregistrer un nouveau compte.";
  @override
  String get deleteAccountConfirmMsg => "Êtes-vous sûr de vouloir supprimer le compte?";
  @override
  String get remark => "Remarque";
  @override
  String get showMore => "Montre plus";
  @override
  String get showLess => "Montrer moins";
  @override
  String get choosePickupAddress => "Choisissez l'adresse de ramassage";
  @override
  String get chooseDeliveryAddress => "Choisissez l'adresse de livraison";
  @override
  String get showingAllAddress => "Affichage de toutes les adresses disponibles";
  @override
  String get addNewAddress => "Ajouter une nouvelle adresse";
  @override
  String get selectPickupLocation => "Sélectionnez l'emplacement de ramassage";
  @override
  String get selectDeliveryLocation => "Sélectionnez le lieu de livraison";
  @override
  String get searchAddress => "Adresse de recherche";
  @override
  String get pleaseWait => "S'il vous plaît, attendez...";
  @override
  String get confirmPickupLocation => "Confirmer l'emplacement de ramassage";
  @override
  String get confirmDeliveryLocation => "Confirmer le lieu de livraison";
  @override
  String get addressNotInArea => "Adresse pas dans la zone";
  @override
  String get wallet => "Portefeuille";
  @override
  String get bankDetails => "Coordonnées bancaires";
  @override
  String get declined => "Diminué";
  @override
  String get requested => "Demandé";
  @override
  String get approved => "Approuvé";
  @override
  String get withdraw => "Retirer";
  @override
  String get availableBalance => "Solde disponible";
  @override
  String get withdrawHistory => "Retirer l'histoire";
  @override
  String get addMoney => "Ajouter de l'argent";
  @override
  String get amount => "Montant";
  @override
  String get credentialNotMatch => "Ces informations d'identification ne correspondent pas à nos records";
  @override
  String get accountNumber => "Numéro de compte";
  @override
  String get nameAsPerBank => "Nom selon la banque";
  @override
  String get ifscCode => "Code IFSC";
  @override
  String get acceptTermService => "Veuillez accepter les conditions d'utilisation et la politique de confidentialité";
  @override
  String get iAgreeToThe => "je suis d'accord avec le";
  @override
  String get termOfService => "Conditions d'utilisation";
  @override
  String get somethingWentWrong => "Quelque chose s'est mal passé";
  @override
  String get userNotFound => "Utilisateur non trouvé";
  @override
  String get balanceInsufficient => "L'équilibre est insuffisant, veuillez ajouter le montant dans votre portefeuille";
  @override
  String get add => "Ajouter";
  @override
  String get bankNotFound => "OPPS, votre détail bancaire est trouvé";
  @override
  String get internetIsConnected => "Internet est connecté.";
  @override
  String get balanceInsufficientCashPayment => "Le solde est insuffisant, la commande est créée avec un paiement en espèces.";
  @override
  String get ok => "D'ACCORD";
  @override
  String get orderFee => "Frais de commande";
  @override
  String get topup => "Secouer";
  @override
  String get orderCancelCharge => "Commandez des frais d'annulation";
  @override
  String get orderCancelRefund => "Commandez le remboursement de l'annulation";
  @override
  String get correction => "Correction";
  @override
  String get commission => "Commission";
  @override
  String get cancelBeforePickMsg =>
      "La commande a été annulée avant de ramasser le colis. Ainsi, seule les frais d'annulation sont réduits. Si le paiement est déjà effectué, le montant est remboursé au portefeuille.";
  @override
  String get cancelAfterPickMsg => "La commande a été annulée après le ramassage du colis. Ainsi, la charge est entièrement coupée.";
  @override
  String get cancelNote => "Remarque: Si vous annulez la commande avant de ramasser le colis, les frais d'annulation seront coupés. Autrement dit, la charge complète sera coupée.";
  @override
  String get earningHistory => "Gagner l'histoire";
  @override
  String get earning => "Revenus";
  @override
  String get adminCommission => "Commission administrative";
  @override
  String get assigned => "Attribué";
  @override
  String get draft => "Brouillon";
  @override
  String get created => "Créé";
  @override
  String get accepted => "Accepté";
  @override
  String get vehicle => "Véhicule";
  @override
  String get selectVehicle => "Sélectionner un véhicule";
  @override
  String get vehicleName => "Nom du véhicule";
  @override
  String get bankName => "Nom de banque";
  @override
  String get courierAssigned => "Courrier affecté";
  @override
  String get courierAccepted => "Courier accepté";
  @override
  String get courierPickedUp => "Pickep";
  @override
  String get courierArrived => "Courier est arrivé";
  @override
  String get courierDeparted => "Courier est parti";
  @override
  String get courierTransfer => "Transfert de courrier";
  @override
  String get paymentStatusMessage => "Message d'état de paiement";
  @override
  String get rejected => "Rejeté";
  @override
  String get notChangeMobileNo => "Vous ne pouvez pas modifier le numéro de contact";
  @override
  String get verification => "Vérification";
  @override
  String get ordersWalletMore => "Commandes, portefeuille et plus";
  @override
  String get general => "Général";
  @override
  String get version => "Version";
  @override
  String get confirmationCode => "Entrez le code de confirmation";
  @override
  String get confirmationCodeSent => "Entrez le code de confirmation a envoyé à";
  @override
  String get getOTP => "Obtenez OTP";
  @override
  String get weSend => "Nous vous enverrons un";
  @override
  String get oneTimePassword => "Mot de passe à usage unique";
  @override
  String get on => "sur";
  @override
  String get phoneNumberVerification => "Vérification du numéro de téléphone";
  @override
  String get location => "Emplacement";
  @override
  String get hey => "Hé";
  @override
  String get markAllRead => "Tout marquer comme lu";
  @override
  String get confirmAccountDeletion => "Confirmer la suppression du compte";

  @override
  String get signWith => "ou se connecter avec";
  @override
  String get selectUserType => "Sélectionner le type d'utilisateur";
  @override
  String get lblUser => "Utilisateur";
  @override
  String get lblDeliveryBoy => "Livreur";
  @override
  String get lblContinue => "Continuer";
  @override
  String get delete => "Supprimer";
  @override
  String get lblMyAddresses => "Mes adresses";
  @override
  String get selectAddressSave => "Sélectionnez l'adresse dans SAVE";
  @override
  String get selectAddress => "Sélectionner l'adresse";
  @override
  String get deleteLocation => "Supprimer l'emplacement?";
  @override
  String get sureWantToDeleteAddress => "Êtes-vous sûr de vouloir supprimer cette adresse?";
  @override
  String get withdrawMoney => 'retirer de l\'argent';
  @override
  String get fromDateValidationMsg => 'À partir de la date est indispensable';
  @override
  String get errorMessage => 'Veuillez réessayer';
  @override
  String get errorSomethingWentWrong => "Quelque chose s'est mal passé";
  @override
  String get errorThisFieldRequired => 'Ce champ est obligatoire';
  @override
  String get errorInternetNotAvailable => 'Votre Internet ne fonctionne pas';
  @override
  String get mustSelectStartDate => 'doit sélectionner la date de début';
  @override
  String get accept => 'Accepter';
  @override
  String get onlineRecievedAmount => 'Montant en ligne reçu';
  @override
  String get totalWithdrawn => 'Montant total de retrait';
  @override
  String get manualRecieved => 'Mannuel reçue';
  @override
  String get lastLocation => 'Dernier lieu';
  @override
  String get latitude => 'Latitude';
  @override
  String get longitude => 'Longitude';
  @override
  String get emailVerification => 'vérification de l\'E-mail';
  @override
  String get getEmail => 'Recevoir un e-mail';
  @override
  String get selectLocation => 'Sélectionnez l\'emplacement';
  @override
  String get demoUserNote => 'Remarque: la recherche d\'adresse de glisser-glisser est désactivée pour l\'utilisateur de démonstration';
  @override
  String get yourOrder => 'Votre commande';
  @override
  String get hasBeenAssignedTo => 'a été affecté à';
  @override
  String get hasBeenTransferedTo => 'a été transféré à';
  @override
  String get lastUpdatedAt => 'Dernière mise à jour à';
  @override
  String get transactionFailed => 'La transaction a échoué!! Essayer à nouveau.';
  @override
  String get orderPickupSuccessfully => 'Félicitations !! Commandez avec succès.';
  @override
  String get orderActiveSuccessfully => 'Félicitations !! Commandez avec succès activé.';
  @override
  String get orderDepartedSuccessfully => 'Félicitations !! L\'ordre a été parti avec succès.';
  @override
  String get orderDeliveredSuccessfully => 'Félicitations !! La commande a été livrée avec succès.';
  @override
  String get addAmount => 'Le champ du montant est vide.Veuillez ajouter le montant';
  @override
  String get invalidUrl => 'URL invalide! .Pelez entre URL valide';
  @override
  String get orderCreated => 'Commande créée';
  @override
  String get distance => 'Distance';
  @override
  String get duration => 'Durée';
  @override
  String get orderAssignConfirmation => 'Êtes-vous sûr de vouloir accepter cette commande ?';
  @override
  String get mAppDescription =>
      'Vous pouvez livrer exactement quand l’utilisateur le souhaite et commencer à traiter sa commande presque immédiatement après l’avoir reçue, ou vous pouvez livrer à un jour et une heure spécifiques.';
  @override
  String get deleteDraft => 'Supprimer le brouillon de commande ?';
  @override
  String get sureWantToDeleteDraft => 'Etes-vous sûr de vouloir supprimer ce brouillon de commande ?"';
  @override
  String get walletHistory => 'Historique du portefeuille';
  @override
  String get newOrderHasBeenCreated => 'Une nouvelle commande a été créée.';
  @override
  String get deliveryPersonArrivedMsg => 'Le livreur est arrivé au lieu de prise en charge et attend le client.';
  @override
  String get deliveryPersonPickedUpCourierMsg => 'Le livreur a récupéré le courrier au lieu de ramassage.';
  @override
  String get hasBeenOutForDelivery => 'est sorti pour livraison.';
  @override
  String get paymentStatusPaisMsg => 'le statut de paiement est payé.';
  @override
  String get deliveredMsg => 'a été livré avec succès.';

}
