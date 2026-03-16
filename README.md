# LingoHands

## Problem Description

In a world where people of different strengths and capabilities constantly interact with each other, it is essential for us to be able to effectively communicate with each other. That being said, it is still a challenge for normal people to effectively communicate with the deaf and inaudible given that their primary means of communication is sign language and most people don’t know sign language. In order to bridge the gap between the groups of people, a system that can aid in facilitating the communication process between the two groups is needed. We have called this system LingoHands. With this system, the deaf and inaudible can effectively communicate with normal individuals in everyday settings.

## Goal

To develop a system that can translate sign language to a form that normal users can understand and vice versa.

## Functional Requirements

- **Real-time Translation of Sign Language Gestures to Text and Speech**: The system should be able to translate sign language gestures from the deaf to text that can be read or speech that can be heard.
- **Real-time Translation of Text and Audio to Sign Language**: The system should be able to translate text and audio input into sign language that can be understood by deaf people.
- **Bidirectional Communication Handling**: The system should be able to fully facilitate communication between users based on their turns. This entails clear transitions between sign-to-speech/text and speech/text-to-sign modes.
- **Customizable Sign Language Standards (Optional)**: The deaf should be able to select and use their preferred sign language standard for communication.

## Non-Functional Requirements

- **Fully Offline Capabilities**: The system should be able to perform sign-to-speech/text and speech/text-to-sign translations without the need for an internet connection.
- **Efficient Storage Usage**: The models used by the system should be as small as possible for improved resource usage. Preferably below 300 MB in total for the system to work after installation.
- **Encrypted Communication**: Interactions between users over the system must be encrypted in order to ensure secure communication between users.
- **Offline Device Pairing**: User devices must establish connections with other user devices before beginning their interactions. This could possibly be done using Bluetooth LE or Wi-Fi direct.
