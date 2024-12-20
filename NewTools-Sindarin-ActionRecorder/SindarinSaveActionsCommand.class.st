Class {
	#name : 'SindarinSaveActionsCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-ActionRecorder',
	#package : 'NewTools-Sindarin-ActionRecorder'
}

{ #category : 'default' }
SindarinSaveActionsCommand class >> defaultDescription [
	^'Save the captured debugging actions as a Sindarin script'
]

{ #category : 'default' }
SindarinSaveActionsCommand class >> defaultIconName [
	^#smallSave
]

{ #category : 'default' }
SindarinSaveActionsCommand class >> defaultName [
	^'Save as Sindarin script'
]

{ #category : 'executing' }
SindarinSaveActionsCommand >> execute [
	self context saveScript
]
