<?xml version="1.0" encoding="UTF-8" ?>
<Package name="NAOProject" format_version="5">
    <Manifest src="manifest.xml" />
    <BehaviorDescriptions>
        <BehaviorDescription name="behavior" src="behavior_1" xar="behavior.xar" />
    </BehaviorDescriptions>
    <Dialogs>
        <Dialog name="AskRestart" src="behavior_1/AskRestart/AskRestart.dlg" />
        <Dialog name="Question1" src="Question1/Question1.dlg" />
        <Dialog name="Question2" src="Question2/Question2.dlg" />
        <Dialog name="Question3" src="Question3/Question3.dlg" />
        <Dialog name="Question4" src="Question4/Question4.dlg" />
        <Dialog name="Question5" src="Question5/Question5.dlg" />
        <Dialog name="Question6" src="Question6/Question6.dlg" />
        <Dialog name="Question7" src="Question7/Question7.dlg" />
        <Dialog name="Question8" src="Question8/Question8.dlg" />
        <Dialog name="Question9" src="Question9/Question9.dlg" />
        <Dialog name="Question10" src="Question10/Question10.dlg" />
    </Dialogs>
    <Resources>
        <File name="icon" src="behavior_1/icon.png" />
        <File name="choice_sentences" src="behavior_1/Aldebaran/choice_sentences.xml" />
        <File name="angry6" src="behavior_1/sounds/angry6.wav" />
        <File name="eto9" src="behavior_1/sounds/eto9.wav" />
        <File name="interested4" src="behavior_1/sounds/interested4.wav" />
        <File name="popup" src="behavior_1/sounds/popup.ogg" />
        <File name="mikhael-landscape-paisaje" src="behavior_1/sounds/mikhael-landscape-paisaje.ogg" />
    </Resources>
    <Topics>
        <Topic name="AskRestart_enu" src="behavior_1/AskRestart/AskRestart_enu.top" topicName="AskRestart" language="en_US" nuance="enu" />
        <Topic name="AskRestart_frf" src="behavior_1/AskRestart/AskRestart_frf.top" topicName="AskRestart" language="fr_FR" nuance="frf" />
        <Topic name="AskRestart_mnc" src="behavior_1/AskRestart/AskRestart_mnc.top" topicName="AskRestart" language="zh_CN" nuance="mnc" />
        <Topic name="Question1_iti" src="Question1/Question1_iti.top" topicName="Question1" language="it_IT" nuance="iti" />
        <Topic name="Question2_iti" src="Question2/Question2_iti.top" topicName="Question2" language="it_IT" nuance="iti" />
        <Topic name="Question3_iti" src="Question3/Question3_iti.top" topicName="Question3" language="it_IT" nuance="iti" />
        <Topic name="Question4_iti" src="Question4/Question4_iti.top" topicName="Question4" language="it_IT" nuance="iti" />
        <Topic name="Question5_iti" src="Question5/Question5_iti.top" topicName="Question5" language="it_IT" nuance="iti" />
        <Topic name="Question6_iti" src="Question6/Question6_iti.top" topicName="Question6" language="it_IT" nuance="iti" />
        <Topic name="Question7_iti" src="Question7/Question7_iti.top" topicName="Question7" language="it_IT" nuance="iti" />
        <Topic name="Question8_iti" src="Question8/Question8_iti.top" topicName="Question8" language="it_IT" nuance="iti" />
        <Topic name="Question9_iti" src="Question9/Question9_iti.top" topicName="Question9" language="it_IT" nuance="iti" />
        <Topic name="Question10_iti" src="Question10/Question10_iti.top" topicName="Question10" language="it_IT" nuance="iti" />
    </Topics>
    <IgnoredPaths />
    <Translations auto-fill="en_US">
        <Translation name="translation_en_US" src="translations/translation_en_US.ts" language="en_US" />
        <Translation name="translation_it_IT" src="translations/translation_it_IT.ts" language="it_IT" />
    </Translations>
</Package>
