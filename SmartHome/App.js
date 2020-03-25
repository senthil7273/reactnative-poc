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

  async _getPlayers() {
    var player = NativeModules.PlayerService;
    this.setState({isLoading: true});
    try {
      var api = "http://dummy.restapiexample.com/api/v1/employees"
      var response = await player.getData({url: api});
      if (response != null) {
        this.setState({playerList: JSON.parse(response)})
      } else {
        alert("Error in getting data "+response)
      }
    } catch(e) {
      alert("error is "+e)
    } finally {
      this.setState({isLoading: false});
    }
  }

  render() {
    return (
      <SafeAreaView style={{flex: 1}}>
      <Container>
        <PlayerHeader/>
     <Content>
      {this.state.isLoading == true && <SpinnerAnimator></SpinnerAnimator>} 
       <List dataArray={this.state.playerList} renderRow ={
         (item) => {return(<ListItem><Text>{item.name}</Text></ListItem>)}
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
