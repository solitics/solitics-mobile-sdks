import * as React from 'react';

import {
  StyleSheet, 
  View, 
  Text,
  Button,
  TextInput
} from 'react-native';

interface LoginProps {
    onLoginButtonClicked: (
        email: String,
        customFields: String,
        keyType: String,
        keyValue: String,
        popupToken: String,
        brand: String,
        branch: String,
        txAmount: String,
        memberId: String
    ) => void
}

const LoginScreen = ({ onLoginButtonClicked }: LoginProps) => {
    const [email, onEmailChanged] = React.useState("sypu@dd.com");
    const [keyType, onKeyTypeChanged] = React.useState("");
    const [keyValue, onKeyValueChanged] = React.useState("");
    const [popupToken, onPopupTokenChanged] = React.useState("DYYUG9UnQ47qhY79mhfcnWCk");
    const [memberId, onMemberIdChanged] = React.useState("811713");
    const [brand, onBrandChanged] = React.useState("eac260cb-732b-4f11-9f48-8f64da66e0c6");
    const [branch, onBranchChanged] = React.useState("");
    const [transactionAmount, onTransactionAmountChanged] = React.useState("0");
    const [customFields, onCustomFieldsChanged] = React.useState("{\"fieldName\": \"fieldValue\"}");

    return (
        <View>
            <Text style={styles.title}>Login</Text>
            <TextInput
                style={styles.input}
                onChangeText={onEmailChanged}
                value={email}
                placeholder="Email"
            />
            <TextInput
                style={styles.input}
                onChangeText={onKeyTypeChanged}
                value={keyType}
                placeholder="Key type"
            />
            <TextInput
                style={styles.input}
                onChangeText={onKeyValueChanged}
                value={keyValue}
                placeholder="Key value"
            />
            <TextInput
                style={styles.input}
                onChangeText={onPopupTokenChanged}
                value={popupToken}
                placeholder="Popup token"
            />
            <TextInput
                style={styles.input}
                onChangeText={onMemberIdChanged}
                value={memberId}
                placeholder="Member ID"
            />
            <TextInput
                style={styles.input}
                onChangeText={onBrandChanged}
                value={brand}
                placeholder="Brand"
            />
            <TextInput
                style={styles.input}
                onChangeText={onBranchChanged}
                value={branch}
                placeholder="Branch"
            />
            <TextInput
                style={styles.input}
                onChangeText={onTransactionAmountChanged}
                value={transactionAmount}
                placeholder="Transaction Amount"
            />
            <TextInput
                style={styles.input}
                onChangeText={onCustomFieldsChanged}
                value={customFields}
                placeholder="Custom fields"
            />
            <View style={{padding: 12}}>
                <Button
                    onPress={() => {
                        onLoginButtonClicked(
                            email, customFields, keyType, keyValue, popupToken, brand, branch, transactionAmount, memberId
                        )
                    }}
                    title='login'/>
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
      marginHorizontal: 12,
      marginVertical: 5,
      borderWidth: 1,
      padding: 10,
      borderRadius: 10,
    }
});

export default LoginScreen;