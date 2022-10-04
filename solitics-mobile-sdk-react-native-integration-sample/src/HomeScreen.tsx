import * as React from 'react';

import {
  StyleSheet, 
  View, 
  Text,
  Button,
  TextInput,
  ScrollView
} from 'react-native';

interface HomeProps {
    onSendEventButtonClicked: (txType: String, txAmount: number, customFields: String) => void
    onLogoutButtonClicked: () => void
    logsToPresent: String
}

const Separator = () => (
    <View style={styles.separator} />
);

const HomeScreen = ({onSendEventButtonClicked, onLogoutButtonClicked, logsToPresent}: HomeProps) => {
    const [txType, onTxTypeChanged] = React.useState("Gini");
    const [customFields, onCustomFieldsChanged] = React.useState("{}");
    const [txAmount, onTxAmountChanged] = React.useState("10");
    const scrollViewRef = React.useRef()

    return (
        <View>
            <Text style={styles.title}>Home Screen</Text>
            <ScrollView contentInsetAdjustmentBehavior="automatic"
                style={styles.logsContainer}
                ref={scrollViewRef}
                onContentSizeChange={() => scrollViewRef.current.scrollToEnd({ animated: true })}>
                
                <Text>{logsToPresent}</Text>
            </ScrollView>
            <TextInput
                style={styles.input}
                onChangeText={onTxTypeChanged}
                value={txType}
                placeholder="Tx type"
            />
            <TextInput
                style={styles.input}
                onChangeText={onCustomFieldsChanged}
                value={customFields}
                placeholder="Custom fields"
            />
            <TextInput
                style={styles.input}
                onChangeText={onTxAmountChanged}
                value={txAmount}
                placeholder="Tx amount"
            />
            <Separator/>
            <View style={styles.fixToText}>
                <Button
                    onPress={() => {
                        onSendEventButtonClicked(txType, Number(txAmount), customFields)
                    }}
                    title='send event'/>
                <Button
                    onPress={onLogoutButtonClicked}
                    title='logout'/>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    title: {
        textAlign: 'center',
        fontSize: 40,
        fontWeight: 'bold',
        paddingTop: 12,
    },
    input: {
      height: 40,
      margin: 12,
      borderWidth: 1,
      padding: 10,
      borderRadius: 10,
    },
    fixToText: {
        flexDirection: 'row',
        justifyContent: 'space-around',
    },
    separator: {
        marginVertical: 8,
    },
    logsContainer: {
        height: 150,
        borderWidth: 2,
        marginVertical: 8,
        marginHorizontal: 4,
        padding: 4,
        borderRadius: 10,
    }
});

export default HomeScreen;