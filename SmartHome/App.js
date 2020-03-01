/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {NativeModules, SafeAreaView, StyleSheet} from 'react-native';
import { Container, Text, Header, Footer, FooterTab , 
  Body, Content, List, ListItem, Title, Button, Spinner} from 'native-base';

const styles = StyleSheet.create({
   buttonContent: {
      color: 'white',
      fontWeight: 'bold',
      fontSize: 16
  }
});

export default class App extends Component {


  constructor() {
    super();
    this.state = {
      playerList:[],
      isLoading: false,
     }
  }
  _getDevice() {
    var deviceManager = NativeModules.DeviceManager;
    deviceManager.getDevices('tv');
  }
  async _getPlayers() {
    var deviceManager = NativeModules.DeviceManager;
    try {
      var host = "dummy.restapiexample.com"
      var scheme = "http"
      var api= "/api/v1/employees"
      var response = await deviceManager.getData({"host":host, "scheme": scheme, "api": api});
      if (response && response.status == "success") {
        this.setState({playerList: response.data})
      } else {
        alert("Error in getting data")
      }
    } catch(e) {
      alert("error is "+e)
    }
  }

  render() {
    return (
      <SafeAreaView style={{flex: 1}}>
      <Container>
        <PlayerHeader/>
     <Content>
      {this.state.isLoading && <SpinnerAnimator></SpinnerAnimator>} 
       <List dataArray={this.state.playerList} renderRow ={
         (item) => {return(<ListItem><Text>{item.employee_name}</Text></ListItem>)}
       }/>
     </Content>
     <Footer>
       <FooterTab>
         <Button full primary onPress={() => {
           this._getPlayers();
         }}>
           <Text style={styles.buttonContent} white>GET DATA</Text>
         </Button>
       </FooterTab>
     </Footer>
    </Container>
    </SafeAreaView>
    );
  }
}

class SpinnerAnimator extends Component {
  render() {
    return(
      <Spinner></Spinner>
    );
  }
}

// HEader component
class PlayerHeader extends Component {

  this
  render() {
    return(
      <Header>
      <Body>
        <Title>
          <Text> PLAYERS </Text>
        </Title>
      </Body>
     </Header>
    );
  }
}
